#!/bin/zsh

#############
## Assumption is that this is run in the storage/pgdb directory using 'source' or '.'
#############

cd ./migrations
migrate create  -ext sql -dir ./ -seq sequence_improvementDetail_id_seq && \
migrate create  -ext sql -dir ./ -seq sequence_jurisdictions_id_seq && \
migrate create  -ext sql -dir ./ -seq sequence_properties_id_seq && \
migrate create  -ext sql -dir ./ -seq sequence_rollvalues_id_seq && \
migrate create  -ext sql -dir ./ -seq sequence_main_roll_values_id_seq && \
migrate create  -ext sql -dir ./ -seq table_jurisdictions && \
migrate create  -ext sql -dir ./ -seq table_land && \
migrate create  -ext sql -dir ./ -seq table_properties && \
migrate create  -ext sql -dir ./ -seq table_proxies && \
migrate create  -ext sql -dir ./ -seq table_roll_values && \
migrate create  -ext sql -dir ./ -seq table_improvement_detail && \
migrate create  -ext sql -dir ./ -seq table_pending_urls
cd ../