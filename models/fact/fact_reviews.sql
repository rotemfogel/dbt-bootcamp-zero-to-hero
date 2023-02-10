{{
    config(
        materialized = 'incremental',
        on_schema_change = 'fail'
    )
}}

WITH staging_reviews AS (
  SELECT *
    FROM {{ ref('staging_reviews') }}
)
SELECT *
  FROM staging_reviews
 WHERE review_text IS NOT NULL
{% if is_incremental() %}
   AND review_date > (SELECT MAX(review_date)
                        FROM {{ this }} )
{% endif %}