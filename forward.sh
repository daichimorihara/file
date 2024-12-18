#!/bin/bash
curl -X GET "https://api.test-env-biz.park-direct.jp/api/v1/contract/009-430-164/" \
     -H "authority: api.test-env-biz.park-direct.jp" \
     -H "method: GET" \
     -H "path: /api/v1/user/" \
     -H "scheme: https" \
     -H "accept: application/json" \
     -H "accept-encoding: gzip, deflate, br, zstd" \
     -H "accept-language: en-US,en;q=0.9" \
     -H "authorization: JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzMzNDAxODEyLCJpYXQiOjE3MzMzODc0MTIsImp0aSI6IjUwMDU5MWQ1MzE1OTQ0MThhMWI5OWRlODMxYTZjMDY3IiwidXNlcl9pZCI6MX0.ZTYkh92iTw9oVgVUjSO2gaLDL9jf8LwldJYhveZSPTQ" \
     -H "origin: https://test-env-biz.park-direct.jp" \
     -H "priority: u=1, i" \
     -H "referer: https://test-env-biz.park-direct.jp/" \
     -H "sec-ch-ua: \"Google Chrome\";v=\"131\", \"Chromium\";v=\"131\", \"Not_A Brand\";v=\"24\"" \
     -H "sec-ch-ua-mobile: ?0" \
     -H "sec-ch-ua-platform: \"macOS\"" \
     -H "sec-fetch-dest: empty" \
     -H "sec-fetch-mode: cors" \
     -H "sec-fetch-site: same-site" \
     -H "user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
