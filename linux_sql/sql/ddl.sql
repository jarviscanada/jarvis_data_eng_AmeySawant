-- Create host_info table to store hardware specifications
CREATE TABLE IF NOT EXISTS host_info (
    id SERIAL PRIMARY KEY,
    hostname VARCHAR NOT NULL,
    cpu_number INT NOT NULL,
    cpu_architecture VARCHAR NOT NULL,
    cpu_model VARCHAR NOT NULL,
    cpu_mhz FLOAT NOT NULL,
    l2_cache INT NOT NULL,
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_mem INT
);

-- Create host_usage table to store resource usage data
CREATE TABLE IF NOT EXISTS host_usage (
    timestamp TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    host_id SERIAL PRIMARY KEY,
    memory_free INT NOT NULL,
    cpu_idle INT NOT NULL,
    cpu_kernel INT NOT NULL,
    disk_io INT NOT NULL,
    disk_available INT NOT NULL,
    CONSTRAINT fk_host_id FOREIGN KEY (host_id) REFERENCES host_info(id)
);

-- Insert sample data into host_info table
INSERT INTO host_info (hostname, cpu_number, cpu_architecture, cpu_model, cpu_mhz, l2_cache, total_mem)
VALUES
    ('jrvs-remote-desktop-centos7-6.us-central1-a.c.spry-framework-236416.internal', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, 601324),
    ('noe1', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, 601324),
    ('noe2', 1, 'x86_64', 'Intel(R) Xeon(R) CPU @ 2.30GHz', 2300, 256, 601324);

-- Insert sample data into host_usage table
INSERT INTO host_usage (timestamp, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES
    ('2019-05-29 15:00:00.000', 300000, 90, 4, 2, 3),
    ('2019-05-29 15:01:00.000', 200000, 90, 4, 2, 3);

