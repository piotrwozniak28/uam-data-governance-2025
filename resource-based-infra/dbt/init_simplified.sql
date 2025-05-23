DROP TABLE IF EXISTS `prj-dev-dbt-aol.bqd_rls.balances`;

CREATE TABLE IF NOT EXISTS `prj-dev-dbt-aol.bqd_rls.balances` (
  balance_id INT64 NOT NULL,
  balance_target STRING,
  balance_status STRING,
  creator_system_id INT64
);

INSERT INTO `prj-dev-dbt-aol.bqd_rls.balances` (
    balance_id,
    balance_target,
    balance_status,
    creator_system_id
)
VALUES
    (1,  'AAA', 'TO_DO',       100),
    (2,  'AAA', 'IN_PROGRESS', 200),
    (3,  'AAA', 'DONE',        300),
    (4,  'AAA', 'TO_DO',       100),

    (5,  'BBB', 'IN_PROGRESS', 200),
    (6,  'BBB', 'DONE',        300),
    (7,  'BBB', 'TO_DO',       100),
    (8,  'BBB', 'IN_PROGRESS', 200),

    (9,  'CCC', 'DONE',        300),
    (10, 'CCC', 'TO_DO',       100),
    (11, 'CCC', 'IN_PROGRESS', 200),
    (12, 'CCC', 'DONE',        300);
