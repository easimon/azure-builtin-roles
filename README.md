# Monitor/Archive of Azure IAM Definitions

Frequently updated list of

- Built-in Azure Role Definitions (not Azure AD roles)
- Azure Providers and their operations (to be used as `actions`/`dataActions` in role definitions)

to track changes over time. Inspired by [MAMIP Monitor AWS Managed IAM Policies](https://github.com/z0ph/MAMIP).

This is a work in progress.

## What it does

There is a [scheduled workflow](.github/workflows/check_azure_updates.yaml) that does the following steps:

- Update the list of Built-In Azure role definitions using `az role definition list`,
  saved as one file per role definition
- Update the list of Azure providers and their operations using `az provider operation list / show`,
  saved as one file per provider
- Reformat them using `jq` to guard a bit against diff noise
- Push any detected additions/removals/modifications, one file at a time

## TODO list

- Monitor AAD roles
- Add twitter bot support, similar to [MAMIP](https://twitter.com/mamip_aws)

## Caveats

### Other subscriptions accounts might show other results

The updater runs against my personal subscription on Azure. I do not know if the list of
built-in roles or providers is the same for each subscription, or if it depends on e.g.
registered providers, registered feature flags etc.
When I checked against a different subscription I have access to, I did not see any
differences, but I don't know if that's globally true.

Feedback / definitive info on that is welcome.

### Role file format

The JSON format here is from `az role definition list`, with the Subscription Id part redacted.
This differs structurally (not only in attribute order) from the Roles JSON view in Azure Portal.

JSON View in Azure Portal: The `id` property is listed first, all other attributes are nested
in a `properties` attribute. Order of attributes seems "natural".

```json
{
    "id": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
    "properties": {
        "roleName": "AcrDelete",
        "description": "acr delete",
        "assignableScopes": [
            "/"
        ],
        "permissions": [
            {
                "actions": [
                    "Microsoft.ContainerRegistry/registries/artifacts/delete"
                ],
                "notActions": [],
                "dataActions": [],
                "notDataActions": []
            }
        ]
    }
}
```

Output of `az role definition list` for the `AcrDelete` role: `properties` subattributes are pulled
up to the top level, everything is sorted alphabetically. I also chose to enforce this attribute
sort order once more in [./scripts/_reformat.sh](./scripts/_reformat.sh), to avoid update noise.
So should Azure ever reorder the JSON attributes when using `az`, this repo will not reflect that.

```json
{
  "assignableScopes": [
    "/"
  ],
  "description": "acr delete",
  "id": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11",
  "name": "c2f4ef07-c644-48eb-af81-4b1b4947fb11",
  "permissions": [
    {
      "actions": [
        "Microsoft.ContainerRegistry/registries/artifacts/delete"
      ],
      "dataActions": [],
      "notActions": [],
      "notDataActions": []
    }
  ],
  "roleName": "AcrDelete",
  "roleType": "BuiltInRole",
  "type": "Microsoft.Authorization/roleDefinitions"
}
```
