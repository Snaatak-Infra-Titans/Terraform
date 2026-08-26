# These records already exist in the persistent private hosted zone. The first
# approved apply imports them into the integrated Dev state and updates only
# their stale values to the fixed database IPs in this wrapper.
import {
  to = aws_route53_record.database["postgresql"]
  id = "Z02920991W3G787FRHSN9_otms.postgresql.internal_A"
}

import {
  to = aws_route53_record.database["redis"]
  id = "Z02920991W3G787FRHSN9_otms.redis.internal_A"
}

import {
  to = aws_route53_record.database["scylladb"]
  id = "Z02920991W3G787FRHSN9_otms.scylladb.internal_A"
}
