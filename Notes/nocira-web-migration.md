
Nocira

Docker
- Frontend: Angular
- Backend: ArangoDB
- Grafana

import existing configurations

terraform import

create a new set records and domains 
https://stackoverflow.com/questions/68852885/create-multiple-dns-route53-a-record-using-terraform



bakcup route53 settings
```
aws --profile default route53 list-resource-record-sets --hosted-zone-id [replace-with-host-id] > route53_config.json
```

Iterate/loop through key value pair
https://stackoverflow.com/questions/68852885/create-multiple-dns-route53-a-record-using-terraform
