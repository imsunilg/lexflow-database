using DbUp;
using Microsoft.Extensions.Configuration;

namespace LexFlow.Database.Runner;

internal static class Program
{
    private static int Main(string[] args)
    {
        var dryRun = args.Contains("--dry-run");
        var scriptsPathArg = GetArgValue(args, "--scripts-path");

        var configuration = new ConfigurationBuilder()
            .SetBasePath(AppContext.BaseDirectory)
            .AddJsonFile("appsettings.json", optional: true, reloadOnChange: false)
            .AddJsonFile("appsettings.Development.json", optional: true, reloadOnChange: false)
            .AddEnvironmentVariables()
            .AddCommandLine(args)
            .Build();

        var scriptsRoot = ResolveScriptsRoot(scriptsPathArg);
        if (scriptsRoot is null)
        {
            Console.Error.WriteLine("Could not locate a 'Scripts' folder. Pass --scripts-path <dir> to specify one explicitly.");
            return 1;
        }

        var scripts = DiscoverScripts(scriptsRoot);

        if (scripts.Count == 0)
        {
            Console.WriteLine($"No .sql scripts found under '{scriptsRoot}'.");
            return 0;
        }

        if (dryRun)
        {
            Console.WriteLine($"Dry run — {scripts.Count} script(s) would execute in this order:");
            foreach (var script in scripts)
            {
                Console.WriteLine($"  {script.Name}");
            }

            return 0;
        }

        var connectionString = ResolveConnectionString(configuration);
        if (string.IsNullOrWhiteSpace(connectionString))
        {
            Console.Error.WriteLine(
                "No connection string configured. Set the LEXFLOW_DB_CONNECTION environment variable " +
                "or ConnectionStrings:LexFlowDatabase in appsettings.json.");
            return 1;
        }

        var upgrader = DeployChanges.To
            .PostgresqlDatabase(connectionString)
            .WithScripts(scripts)
            .JournalToPostgresqlTable("public", "dbup_schema_versions")
            .LogToConsole()
            .Build();

        var result = upgrader.PerformUpgrade();

        if (!result.Successful)
        {
            Console.Error.WriteLine(result.Error);
            return 1;
        }

        Console.WriteLine($"Success — {scripts.Count} script(s) considered, database is up to date.");
        return 0;
    }

    private static string? ResolveConnectionString(IConfiguration configuration)
    {
        var fromEnv = Environment.GetEnvironmentVariable("LEXFLOW_DB_CONNECTION");
        if (!string.IsNullOrWhiteSpace(fromEnv))
        {
            return fromEnv;
        }

        return configuration.GetConnectionString("LexFlowDatabase");
    }

    /// <summary>
    /// DbUp orders scripts by name, so scripts are pre-sorted here using the full
    /// relative path (e.g. "02_Core/Users/001_Table.sql") as that Name — this is what
    /// guarantees 00_.../001_...sql runs before 01_.../001_...sql, per Build Playbook §1.1.
    /// </summary>
    private static List<DbUp.Engine.SqlScript> DiscoverScripts(string scriptsRoot)
    {
        return Directory.EnumerateFiles(scriptsRoot, "*.sql", SearchOption.AllDirectories)
            .Select(path => new
            {
                Path = path,
                RelativeName = Path.GetRelativePath(scriptsRoot, path).Replace('\\', '/')
            })
            .OrderBy(x => x.RelativeName, StringComparer.Ordinal)
            .Select(x => new DbUp.Engine.SqlScript(x.RelativeName, File.ReadAllText(x.Path)))
            .ToList();
    }

    private static string? ResolveScriptsRoot(string? explicitPath)
    {
        if (!string.IsNullOrWhiteSpace(explicitPath))
        {
            return Directory.Exists(explicitPath) ? Path.GetFullPath(explicitPath) : null;
        }

        // Try the current working directory first (the common case: `dotnet run` from repo root).
        var candidates = new[] { Directory.GetCurrentDirectory(), AppContext.BaseDirectory };

        foreach (var start in candidates)
        {
            var dir = new DirectoryInfo(start);
            for (var i = 0; i < 8 && dir is not null; i++, dir = dir.Parent)
            {
                var candidate = Path.Combine(dir.FullName, "Scripts");
                if (Directory.Exists(candidate))
                {
                    return candidate;
                }
            }
        }

        return null;
    }

    private static string? GetArgValue(string[] args, string name)
    {
        var index = Array.IndexOf(args, name);
        return index >= 0 && index + 1 < args.Length ? args[index + 1] : null;
    }
}
