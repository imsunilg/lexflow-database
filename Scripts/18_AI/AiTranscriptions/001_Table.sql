-- PRD Module 16 feature #10 (Voice Notes to Text) / #11 (Meeting Summary): "mobile/web
-- dictation -> Whisper-class STT -> formatted note attached to matter" / "upload/auto-pull
-- meeting recording -> transcript -> summary + decisions + action items." APIs:
-- "POST /api/v1/ai/transcribe (multipart audio)." Async pipeline: rows start Queued, a
-- Hangfire job flips Processing -> Done/Failed and pushes a SignalR notify on completion.
-- tenant_id: NOT NULL, no physical FK — see 02_Core/Tenants/001_Table.sql.
-- matter_id/requested_by FKs are backward-safe and added below.
CREATE TABLE ai.ai_transcriptions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id uuid NOT NULL,
  matter_id uuid,
  requested_by uuid,
  status text NOT NULL DEFAULT 'Queued',
  blob_path text NOT NULL,
  duration_sec int,
  language text,
  transcript_text text,
  error_message text,
  created_at timestamptz NOT NULL DEFAULT now(),
  completed_at timestamptz
);
