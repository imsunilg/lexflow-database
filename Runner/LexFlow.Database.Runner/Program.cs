using DbUp;
using DbUp.Engine;
using Microsoft.Extensions.Configuration;

var dryRun = args.Any(a => a.Equals("--dry-run", StringComparison.OrdinalIgnoreCase));

var configuration = new ConfigurationBuilder()
    .SetBasePath(AppContext.BaseDirectory)
    .AddJsonFile("appsettings.json", optional: true, reloadOnChange: false)
    .AddEnvironmentVariables()
    .Build();

var scriptsRoot = ResolveScriptsRoot(configuration["ScriptsPath"]);
var scripts = DiscoverScripts(scriptsRoot);

Console.WriteLine($"Discovered {scripts.Count} script(s) under '{scriptsRoot}'.");
Console.WriteLine();
Console.WriteLine("Execution order:");
for (var i = 0; i < scripts.Count; i++)
{
    Console.WriteLine($"  {i + 1,4}. {scripts[i].Name}");
}

if (dryRun)
{
    Console.WriteLine();
    Console.WriteLine("Dry run complete. No changes were applied.");
    return 0;
}

var connectionString = configuration["LEXFLOW_DB_CONNECTION"]
    ?? configuration.GetConnectionString("LexFlowDatabase");

if (string.IsNullOrWhiteSpace(connectionString))
{
    Console.Error.WriteLine(
        "No connection string found. Set 'ConnectionStrings:LexFlowDatabase' in appsettings.json " +
        "or the LEXFLOW_DB_CONNECTION environment variable.");
    return 1;
}

Console.WriteLine();
Console.WriteLine("Applying scripts...");

EnsureDatabase.For.PostgresqlDatabase(connectionString);

var upgradeEngine = DeployChanges.To
    .PostgresqlDatabase(connectionString)
    .WithScripts(scripts)
    .JournalToPostgresqlTable("public", "dbup_schema_versions")
    .WithTransactionPerScript()
    .LogToConsole()
    .Build();

var result = upgradeEngine.PerformUpgrade();

if (!result.Successful)
{
    Console.ForegroundColor = ConsoleColor.Red;
    Console.Error.WriteLine(result.Error);
    Console.ResetColor();
    return 1;
}

Console.ForegroundColor = ConsoleColor.Green;
Console.WriteLine("Schema upgrade successful.");
Console.ResetColor();
return 0;

// Locates the repository's Scripts/ folder: an explicit ScriptsPath config value wins;
// otherwise walk up from both the working directory and the executable's directory
// looking for a folder that contains both "Scripts" and "Runner" (the fixed repo layout).
static string ResolveScriptsRoot(string? configuredPath)
{
    if (!string.IsNullOrWhiteSpace(configuredPath))
    {
        var resolved = Path.GetFullPath(configuredPath);
        if (!Directory.Exists(resolved))
        {
            throw new DirectoryNotFoundException($"Configured ScriptsPath '{resolved}' does not exist.");
        }

        return resolved;
    }

    foreach (var start in new[] { Directory.GetCurrentDirectory(), AppContext.BaseDirectory })
    {
        var dir = new DirectoryInfo(start);
        while (dir is not null)
        {
            var candidate = Path.Combine(dir.FullName, "Scripts");
            if (Directory.Exists(candidate) && Directory.Exists(Path.Combine(dir.FullName, "Runner")))
            {
                return candidate;
            }

            dir = dir.Parent;
        }
    }

    throw new DirectoryNotFoundException(
        "Could not locate the repository's Scripts/ directory. Set 'ScriptsPath' in appsettings.json " +
        "or run from within the lexflow-database repository.");
}

// Discovers every .sql file under scriptsRoot and orders them by full relative path
// (forward-slash normalized so ordering is identical on Windows and Linux), which is
// what makes "00_.../001_...sql" run before "01_.../001_...sql", etc.
static List<SqlScript> DiscoverScripts(string scriptsRoot)
{
    return Directory.EnumerateFiles(scriptsRoot, "*.sql", SearchOption.AllDirectories)
        .Select(fullPath => new
        {
            FullPath = fullPath,
            RelativePath = Path.GetRelativePath(scriptsRoot, fullPath).Replace('\\', '/')
        })
        .OrderBy(f => f.RelativePath, StringComparer.Ordinal)
        .Select(f => new SqlScript(f.RelativePath, File.ReadAllText(f.FullPath)))
        .ToList();
}
