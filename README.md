# JupyterHealth helm charts

Helm Charts for JupyterHealth.

Currently just [jhe](./jhe).

JHE chart is published at https://ghcr.io/jupyterhealth/helm/jhe

Status so far:

## JHE

Fully working and production ready.

## MCP

MPC Server is disabled by default, and enabled by:

```yaml
mcp:
  enabled: true
```

## Caveats

The seed function of JHE is insecure and should not be used except for testing (https://github.com/jupyterhealth/jupyterhealth-exchange/issues/281).
If used, immediately create new accounts with secure passwords and delete the seeded ones.

Many options require manual configuration, and some can only be loaded from configuration once.
If not loaded at seed time, they must be set via the JHE settings UI (or django admin UI).

## Setting open Open Wearables

Currently, open

Make sure to set:

```python
openWearables:
  enabled: true
  backend:
    env:
      ADMIN_EMAIL: some-admin@example.org
      ADMIN_PASSWORD:
```

Note: the admin account will. If you enable openWearables without setting admin email, it will seed with an insecure, publicly known email and password.

To change the admin password after the open-wearables database has been seeded:

```python
r = requests.post(
  ow_url / "api/v1/auth/login",
  data={"username": admin_email, "password": current_password},
)
r.raise_for_status()
token = r.json()["access_token"]

r = requests.post(
  ow_url / "api/v1/auth/change-password",
  headers={"Authorization": f"Bearer {token}"},
  json={"current_password": current_password, "new_password": new_password},
)
```

To issue an API Key for JHE:

```python
r = requests.post(
  ow_url / "api/v1/auth/login",
  data={"username": admin_email, "password": admin_password},
)
r.raise_for_status()
token = r.json()["access_token"]

r = requests.post(
  ow_url / "api/v1/developers/api-keys",
  headers={"Authorization": f"Bearer {token}"},
  json={"name": "JHE"},
)
r.raise_for_status()
print(r.json()['key'])
# gives `sk-abc123.....`
```

Then go to your JHE settings and set:

- `ow.api_key` to the new key
- `ow.api_url` to the correct URL (Should be `http://${name}-ow` where `${name}` is the name of your Helm deployment)
- `module.ow` to true
