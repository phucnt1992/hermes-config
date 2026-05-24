-- PostgreSQL 18 cluster-level tuning for nuq workloads.
--
-- Apply this file intentionally as a privileged step (superuser),
-- outside bootstrap schema migrations.

-- Checkpoint settings: spread I/O without excessively long WAL bursts.
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET checkpoint_timeout = '10min';
ALTER SYSTEM SET max_wal_size = '8GB';
ALTER SYSTEM SET min_wal_size = '2GB';

-- Background writer: moderate pre-flush behavior for smoother checkpoints.
ALTER SYSTEM SET bgwriter_lru_maxpages = 500;
ALTER SYSTEM SET bgwriter_lru_multiplier = 2.0;
ALTER SYSTEM SET bgwriter_delay = '50ms';
ALTER SYSTEM SET bgwriter_flush_after = '1MB';

-- I/O concurrency for SSD/cloud storage.
ALTER SYSTEM SET effective_io_concurrency = 200;
ALTER SYSTEM SET maintenance_io_concurrency = 100;

-- WAL writer settings.
ALTER SYSTEM SET wal_buffers = '32MB';
ALTER SYSTEM SET wal_writer_delay = '20ms';
ALTER SYSTEM SET wal_writer_flush_after = '1MB';

-- Disable explicit commit delay tuning (prefer defaults in PG18).
ALTER SYSTEM RESET commit_delay;
ALTER SYSTEM RESET commit_siblings;

SELECT pg_reload_conf();

-- Verification helpers
SHOW checkpoint_timeout;
SHOW max_wal_size;
SHOW min_wal_size;
SHOW wal_buffers;
SHOW commit_delay;
SHOW commit_siblings;
