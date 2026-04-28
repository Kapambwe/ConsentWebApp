# Sample Data Inventory

Root: `wwwroot/sample-data/{country}/{institutionType}/{institutionName}`

## Countries
- `botswana`
- `kenya`
- `malawi`
- `namibia`
- `nigeria`
- `south-africa`
- `tanzania`
- `uganda`
- `usa`
- `zambia`
- `zimbabwe`

## Institution Folder Rule
Every institution folder currently contains the standard seed set:
- `authcomponent.json`
- `users.json`
- `role-permission.json`
- `dashboard.json`
- `consent_history.json`
- `active_consents.json`
- `projects.json`
- `institutional_data.json`
- `small_businesses.json`
- `financial_statements.json`
- `collateral.json`
- `animal_data.json`
- `farming_data.json`
- `artisan_services.json`
- `mining_operations.json`
- `investor_marketplace.json`
- `energy_projects.json`
- `climate_finance.json`
- `carbon_projects.json`
- `infrastructure_projects.json`
- `loans.json`
- `monitoring_history.json`

## Notes
- The inventory is generated from the current folder tree under `wwwroot/sample-data`.
- Each institution folder is expected to follow the same file contract so mock services can resolve data by selected country, institution type, and institution name.
