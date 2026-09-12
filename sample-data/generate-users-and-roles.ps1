param(
    [string]$Root = (Join-Path $PSScriptRoot '.'),
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

$structurePath = Join-Path $Root 'directory-structure.json'
if (-not (Test-Path $structurePath)) {
    throw "Missing directory structure file: $structurePath"
}

$structure = Get-Content $structurePath -Raw | ConvertFrom-Json

function Normalize-Key {
    param([Parameter(Mandatory)] [string]$Value)
    ($Value.Trim().ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
}

function Write-JsonFile {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [object]$Value
    )

    if ((Test-Path $Path) -and -not $Force) {
        return
    }

    $Value | ConvertTo-Json -Depth 12 | Set-Content -Path $Path
}

function New-UsersPayload {
    param(
        [Parameter(Mandatory)] [string]$Country,
        [Parameter(Mandatory)] [string]$InstitutionType,
        [Parameter(Mandatory)] [string]$InstitutionName
    )

    $code = if ($Country.Length -ge 2) { $Country.Substring(0,2).ToUpperInvariant() } else { $Country.ToUpperInvariant() }

    @{
        users = @(
            @{
                id = "USR-$code-001"
                username = 'admin'
                displayName = 'Institution Admin'
                email = "admin@$Country.sample"
                role = 'Administrator'
                status = 'Active'
            },
            @{
                id = "USR-$code-002"
                username = 'officer'
                displayName = 'Institution Officer'
                email = "officer@$Country.sample"
                role = 'Officer'
                status = 'Active'
            }
        )
    }
}

function New-RolePermissionPayload {
    @{
        roles = @(
            @{
                name = 'Administrator'
                permissions = @(
                    'Consent.Admin.ViewTemplates',
                    'Consent.Admin.ViewVerifiableCredentials',
                    'Consent.Admin.ViewIssuers',
                    'Consent.Institutional.ViewDashboard',
                    'Consent.Institutional.ViewRequests',
                    'Consent.Institutional.ViewMarketplace',
                    'Consent.Institutional.ViewWarehouseReceipts',
                    'Consent.Institutional.ManageWarehouseReceipts'
                )
            },
            @{
                name = 'Officer'
                permissions = @(
                    'Consent.Institutional.ViewDashboard',
                    'Consent.Institutional.ViewRequests',
                    'Consent.Institutional.ViewMarketplace',
                    'Consent.Institutional.ViewWarehouseReceipts'
                )
            }
        )
    }
}

foreach ($countryProp in $structure.PSObject.Properties) {
    $country = Normalize-Key $countryProp.Name

    foreach ($typeProp in $countryProp.Value.PSObject.Properties) {
        $institutionType = Normalize-Key $typeProp.Name

        foreach ($institution in $typeProp.Value) {
            $institutionName = Normalize-Key $institution
            $folder = Join-Path $Root (Join-Path $country (Join-Path $institutionType $institutionName))
            if (-not (Test-Path $folder)) {
                New-Item -ItemType Directory -Path $folder -Force | Out-Null
            }

            Write-JsonFile -Path (Join-Path $folder 'users.json') -Value (New-UsersPayload -Country $country -InstitutionType $institutionType -InstitutionName $institutionName)
            Write-JsonFile -Path (Join-Path $folder 'role-permission.json') -Value (New-RolePermissionPayload)
        }
    }
}

Write-Host 'users.json and role-permission.json generated successfully.'
