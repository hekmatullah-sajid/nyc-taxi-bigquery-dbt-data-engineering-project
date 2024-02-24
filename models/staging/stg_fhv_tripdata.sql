{{
    config(
        materialized='view'
    )
}}

with 
source as (
    select * from {{ source('staging', 'fhv_tripdata') }}
),

tripdata as (

    select
        {{ dbt_utils.generate_surrogate_key(["dispatching_base_num", "pickup_datetime"]) }} as tripid,
        dispatching_base_num,
        pickup_datetime,
        dropoff_datetime,
        pulocationid,
        dolocationid,
        sr_flag,
        affiliated_base_number

    from source

)

select * from tripdata

-- dbt build --select <model_name> --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}