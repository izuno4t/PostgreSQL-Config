--
-- check_pg_settings.sql
--
-- Copyright(C) 2012 Uptime Technologies, LLC. All rights reserved.
-- see http://pgsqldeepdive.blogspot.jp/2012/12/postgresql.html
-- see https://gist.github.com/4179435
--
SELECT name,
       setting,
       CASE WHEN setting::integer = 4096 THEN 'WARNING: default value (4096=32MB) is too small.'
            WHEN setting::integer < 65536 THEN 'WARNING: too small. (<65536=512MB)'
            ELSE 'OK.'
       END AS result
       FROM pg_settings WHERE name = 'shared_buffers'

UNION ALL

SELECT name,
       setting,
       CASE WHEN setting::integer = -1 THEN 'WARNING: default value.'
            WHEN setting::integer < 1024 THEN 'WARNING: too small. (<1024=8MB)'
            ELSE 'OK.'
       END AS result
       FROM pg_settings WHERE name = 'wal_buffers'

UNION ALL

SELECT name,
       setting,
       CASE WHEN setting::integer = 3 THEN 'WARNING: default value (3) is too small.'
            WHEN setting::integer < 64 THEN 'WARNING: too small. (<64)'
            ELSE 'OK.'
       END AS result
       FROM pg_settings WHERE name = 'checkpoint_segments'

UNION ALL

SELECT name,
       setting,
       CASE WHEN setting::integer = 300 THEN 'WARNING: default value (300=5m) is too small.'
            WHEN setting::integer < 3600 THEN 'WARNING: too small. (<3600=60m)'
            ELSE 'OK.'
       END AS result
       FROM pg_settings WHERE name = 'checkpoint_timeout'

UNION ALL

SELECT name,
       setting,
       CASE WHEN setting = 'minimal' THEN 'WARNING: `minimal'' cannot enable archive log mode.'
            WHEN setting = 'archive' THEN 'OK.'
            WHEN setting = 'hot_standby' THEN 'OK.'
       END AS result
       FROM pg_settings WHERE name = 'wal_level'

UNION ALL

SELECT name,
       setting,
       CASE WHEN setting = 'off' THEN 'WARNING: archive log mode is disabled.'
            ELSE 'OK.'
       END AS result
       FROM pg_settings WHERE name = 'archive_mode'

UNION ALL

SELECT name,
       setting,
       CASE WHEN setting = '(disabled)' THEN 'WARNING: archive log mode is disabled.'
            WHEN setting = '' THEN 'WARNING: empty by the default. need to set an archive command.'
            WHEN strpos(setting, '%p') > 0 AND strpos(setting, '%f') > 0 THEN 'OK.'
            ELSE 'WARNING: make sure to have an archive command correctly.'
       END AS result
       FROM pg_settings WHERE name = 'archive_command'

UNION ALL

SELECT name,
       setting,
       CASE WHEN setting::integer = 0 THEN 'WARNING: archive timeout is disabled.'
            WHEN setting::integer < 3600 THEN 'WARNING: too short. (<60m)'
            ELSE 'OK.'
       END AS result
       FROM pg_settings WHERE name = 'archive_timeout'

UNION ALL

SELECT name,
       setting,
       CASE WHEN setting = '' THEN 'WARNING: empty by the default. need to have pid (%p) and timestamp (%t) at least.'
            WHEN strpos(setting, '%p') > 0 AND strpos(setting, '%t') > 0 THEN 'OK.'
            ELSE 'WARNING: need to have pid (%p) and timestamp (%t) at least.'
       END AS result
       FROM pg_settings WHERE name = 'log_line_prefix'

;
