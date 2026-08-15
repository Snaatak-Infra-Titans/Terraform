# Network Skeleton CI fixture

This root module exists only to initialize, validate, plan, scan, and estimate the
cost of `Modules/Network_Skeleton` in Jenkins. It deliberately has no backend
configuration and contains no AWS credentials.

Jenkins supplies AWS credentials and `us-east-1` at runtime. The saved CI plan is
not a deployment artifact and must not be passed to CD. A later CD workflow must
use the real environment wrapper, remote backend, reviewed variables, and a new
saved plan before applying.
