CREATE OR REPLACE FUNCTION public.create_month_partition(
    p_year INTEGER,
    p_month INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
DECLARE
start_ts TIMESTAMPTZ;
    end_ts   TIMESTAMPTZ;
    part_name TEXT;
BEGIN
    start_ts := make_date(p_year, p_month, 1)::timestamptz;
    end_ts := (make_date(p_year, p_month, 1) + INTERVAL '1 month')::timestamptz;
    part_name := format('tracks_%s_%s', p_year, LPAD(p_month::TEXT, 2, '0'));

    IF NOT EXISTS (
        SELECT 1
        FROM pg_inherits i
        JOIN pg_class c ON i.inhrelid = c.oid
        WHERE c.relname = part_name
    ) THEN
        EXECUTE format(
            'CREATE TABLE %I PARTITION OF public.tracks FOR VALUES FROM (%L) TO (%L)',
            part_name, start_ts, end_ts
        );
END IF;
END;
$$;
