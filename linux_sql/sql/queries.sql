-- Sample SQL queries for data analysis
-- Query 1: Average memory usage per host for the last hour
SELECT hostname, AVG(memory_free) AS avg_memory_usage
FROM host_info
JOIN host_usage ON host_info.id = host_usage.host_id
WHERE timestamp >= NOW() - INTERVAL '1 hour'
GROUP BY hostname;

-- Query 2: CPU idle percentage for each host for the last 24 hours
SELECT hostname, AVG(cpu_idle) AS avg_cpu_idle
FROM host_info
JOIN host_usage ON host_info.id = host_usage.host_id
WHERE timestamp >= NOW() - INTERVAL '24 hour'
GROUP BY hostname;
