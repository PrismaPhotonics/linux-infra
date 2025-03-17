insert into prisma_projects.customers (id, name, region, bucket, active)
values  (17, 'Shaked', 'eu', 'pz-operational', 0);

insert into prisma_projects.data_collection_mongo_params (id, site, site_name, machine_name, mongo_db, collection, increment_field, last_collected_time, frequency_minutes, plan_end_time, enable, on_demand)
values  (1, 61, 'Shaked_O', 'prisma-210-1020', 'Alerts', 'Algoruns', 'algorun.execution_time_end', '2025-03-02 16:28:00.000000', 60, '2999-12-31 00:00:00.000000', 1, 0),
        (2, 61, 'Shaked_O', 'prisma-210-1020', 'Alerts', 'pulse-alert', 'alert_time', '2025-03-02 16:28:00.000000', 5, '2999-12-31 00:00:00.000000', 1, 0),
        (8, 33, 'Shaked_G', 'prisma-210-1015', 'Alerts', 'pulse-alert', 'alert_time', '2025-03-02 16:28:00.000000', 5, '2999-12-31 00:00:00.000000', 1, 0),
        (4, 59, 'Shaked_K', 'prisma-210-1091', 'Alerts', 'pulse-alert', 'alert_time', '2025-03-02 16:28:00.000000', 5, '2999-12-31 00:00:00.000000', 1, 0),
        (10, 97, 'Shaked_NR', 'prisma-210-1094', 'Alerts', 'Algoruns', 'algorun.execution_time_end', '2025-03-02 16:28:00.000000', 60, '2999-12-31 00:00:00.000000', 1, 0),
        (7, 33, 'Shaked_G', 'prisma-210-1015', 'Alerts', 'Algoruns', 'algorun.execution_time_end', '2025-03-02 16:28:00.000000', 60, '2999-12-31 00:00:00.000000', 1, 0),
        (3, 59, 'Shaked_K', 'prisma-210-1091', 'Alerts', 'Algoruns', 'algorun.execution_time_end', '2025-03-02 16:28:00.000000', 60, '2999-12-31 00:00:00.000000', 1, 0),
        (5, 60, 'Shaked_E', 'prisma-210-1037', 'Alerts', 'Algoruns', 'algorun.execution_time_end', '2025-03-02 16:28:00.000000', 60, '2999-12-31 00:00:00.000000', 1, 0),
        (6, 60, 'Shaked_E', 'prisma-210-1037', 'Alerts', 'pulse-alert', 'alert_time', '2025-03-02 16:28:00.000000', 5, '2999-12-31 00:00:00.000000', 1, 0),
        (9, 97, 'Shaked_NR', 'prisma-210-1094', 'Alerts', 'pulse-alert', 'alert_time', '2025-03-02 16:28:00.000000', 5, '2999-12-31 00:00:00.000000', 1, 0);

insert into prisma_projects.sites (siteid, name, fiberlength_m, countrycode, timezone, customer, application, machine_name, ip, active, name_origin, machine_url)
values  (60, 'Shaked_E', 5950, 'IL', 'Asia/Jerusalem', 'Shaked', 'Eagle', 'prisma-210-1037', '10.212.50.12', 1, 'Shaked_E', 'prisma-210-1037.prisma.external'),
        (61, 'Shaked_O', 7000, 'IL', 'Asia/Jerusalem', 'Shaked', 'Eagle', 'prisma-210-1020', '10.212.50.13', 1, 'Shaked_O', 'prisma-210-1020.prisma.external'),
        (33, 'Shaked_G', 3800, 'IL', 'Asia/Jerusalem', 'Shaked', 'Eagle', 'prisma-210-1015', '10.212.50.10', 1, 'Shaked_G', 'prisma-210-1015.prisma.external'),
        (59, 'Shaked_K', 8000, 'IL', 'Asia/Jerusalem', 'Shaked', 'Eagle', 'prisma-210-1091', '10.212.70.38', 1, 'Shaked_K', 'prisma-210-1091.prisma.external'),
        (97, 'Shaked_NR', 6000, 'IL', 'Asia/Jerusalem', 'Shaked', 'Eagle', 'prisma-210-1094', '10.212.70.41', 1, 'Shaked_NR', 'prisma-210-1094.prisma.external');

