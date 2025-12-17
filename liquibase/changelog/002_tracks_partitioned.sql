-- Base table partitioned by month on recorded_at
CREATE TABLE IF NOT EXISTS public.tracks (
  track_id BIGSERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  artist TEXT NOT NULL,
  album TEXT,
  duration_ms INTEGER NOT NULL,
  recorded_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
) PARTITION BY RANGE (recorded_at);

-- Helper function to create monthly partitions
CREATE OR REPLACE FUNCTION public.create_month_partition(p_year INTEGER, p_month INTEGER)
RETURNS VOID AS $$
DECLARE
  start_ts TIMESTAMPTZ;
  end_ts   TIMESTAMPTZ;
  part_name TEXT;
BEGIN
  start_ts := make_timestamptz(p_year, p_month, 1, 0, 0, 0, 'UTC');
  end_ts := (start_ts + INTERVAL '1 month');
  part_name := format('tracks_%s_%s', p_year, LPAD(p_month::TEXT, 2, '0'));

  EXECUTE format('CREATE TABLE IF NOT EXISTS %I PARTITION OF public.tracks FOR VALUES FROM (%L) TO (%L);',
                 part_name, start_ts, end_ts);

  EXECUTE format('CREATE INDEX IF NOT EXISTS %I_idx_recorded_at ON %I (recorded_at);', part_name || '_rec', part_name);
  EXECUTE format('CREATE INDEX IF NOT EXISTS %I_idx_trgm ON %I USING GIN ((title || '' '' || artist || '' '' || coalesce(album, '''')) gin_trgm_ops);', part_name || '_trgm', part_name);
END; $$ LANGUAGE plpgsql;

-- Create initial partitions
SELECT public.create_month_partition(2025, 12);
SELECT public.create_month_partition(2026, 1);
SELECT public.create_month_partition(2026, 2);
SELECT public.create_month_partition(2026, 3);
SELECT public.create_month_partition(2026, 4);
SELECT public.create_month_partition(2026, 5);
SELECT public.create_month_partition(2026, 6);
SELECT public.create_month_partition(2026, 7);
SELECT public.create_month_partition(2026, 8);
SELECT public.create_month_partition(2026, 9);
SELECT public.create_month_partition(2026, 10);
SELECT public.create_month_partition(2026, 11);
SELECT public.create_month_partition(2026, 12);
