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

$standardFiles = @(
    'authcomponent.json',
    'users.json',
    'role-permission.json',
    'dashboard.json',
    'consent_history.json',
    'active_consents.json',
    'projects.json',
    'institutional_data.json',
    'small_businesses.json',
    'financial_statements.json',
    'collateral.json',
    'animal_data.json',
    'farming_data.json',
    'artisan_services.json',
    'mining_operations.json',
    'investor_marketplace.json',
    'energy_projects.json',
    'climate_finance.json',
    'carbon_projects.json',
    'infrastructure_projects.json',
    'loans.json',
    'monitoring_history.json'
)

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

function Get-BasePayload {
    param(
        [Parameter(Mandatory)] [string]$Country,
        [Parameter(Mandatory)] [string]$InstitutionType,
        [Parameter(Mandatory)] [string]$InstitutionName
    )

    $code = if ($Country.Length -ge 2) { $Country.Substring(0,2).ToUpperInvariant() } else { $Country.ToUpperInvariant() }
    $today = (Get-Date).ToString('o')

    @{
        'authcomponent.json' = @{
            institutionName = $InstitutionName
            institutionType = $InstitutionType
            country = $Country
            loginMode = 'mock'
            lastLoginAt = $today
        }
        'users.json' = @{
            users = @(
                @{ id = "USR-$code-001"; username = 'admin'; displayName = 'Institution Admin'; email = "admin@$Country.sample"; role = 'Administrator'; status = 'Active' },
                @{ id = "USR-$code-002"; username = 'officer'; displayName = 'Institution Officer'; email = "officer@$Country.sample"; role = 'Officer'; status = 'Active' }
            )
        }
        'role-permission.json' = @{
            roles = @(
                @{ name = 'Administrator'; permissions = @('Consent.Admin.ViewTemplates','Consent.Admin.ViewVerifiableCredentials','Consent.Admin.ViewIssuers','Consent.Institutional.ViewDashboard','Consent.Institutional.ViewRequests','Consent.Institutional.ViewMarketplace','Consent.Institutional.ViewWarehouseReceipts','Consent.Institutional.ManageWarehouseReceipts') },
                @{ name = 'Officer'; permissions = @('Consent.Institutional.ViewDashboard','Consent.Institutional.ViewRequests','Consent.Institutional.ViewMarketplace','Consent.Institutional.ViewWarehouseReceipts') }
            )
        }
        'dashboard.json' = @{
            country = $Country
            institution = $InstitutionName
            lastUpdated = $today
            totalConsents = 18
            activeConsents = 11
            pendingRequests = 2
            approvedRequests = 1
            rejectedRequests = 1
        }
        'consent_history.json' = @{
            items = @(
                @{ consentId = "CON-$code-001"; customerId = "CUST-$code-001"; action = 'Granted'; timestamp = (Get-Date).AddDays(-20).ToString('o') }
            )
        }
        'active_consents.json' = @{
            items = @(
                @{ consentId = "CON-$code-002"; customerId = "CUST-$code-002"; status = 'Active'; expires = (Get-Date).AddDays(60).ToString('o') }
            )
        }
        'projects.json' = @{
            projects = @(
                @{ id = 1; title = "$InstitutionName Strategic Project"; sector = 'General'; requiredInvestment = 50000; isVerified = $true; location = $Country; createdDate = (Get-Date).AddDays(-12).ToString('o') }
            )
        }
        'institutional_data.json' = @{
            Requests = @(
                @{ Id = "REQ-$code-001"; SubjectName = "$InstitutionName Customer"; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' }
            )
            Opportunities = @(
                @{ Id = "OPP-$code-001"; BusinessName = "$InstitutionName Customer"; DisciplineScore = 80; VerifiedRevenue = 125000; TaxComplianceStatus = 'Compliant'; TaskCompletionRate = 88; LastMonthGrowth = 9; ActiveContractCount = 2; TotalAssetValue = 250000 }
            )
            VerificationHistory = @(
                @{ Id = "PROOF-$code-001"; SubjectName = "$InstitutionName Customer"; DocumentType = 'Tax Clearance'; Verified = $true; VerifiedBy = 'Authority'; VerifiedAt = (Get-Date).AddDays(-3).ToString('o') }
            )
        }
        'small_businesses.json' = @{
            Businesses = @(
                @{ Id = "SB-$code-001"; BusinessName = "$InstitutionName Customer"; Sector = 'General Commerce'; LoanAmount = 25000; UseOfFunds = 55; RepaymentScore = 76; RiskScore = 35; Status = 'Funded' }
            )
        }
        'financial_statements.json' = @{
            balanceSheet = @{ totalAssets = 2850000; totalLiabilities = 1200000; equity = 1650000; currentRatio = 2.3 }
            incomeStatement = @{ revenue = 1850000; expenses = 1250000; netProfit = 600000; profitMargin = 32.4 }
            cashFlowStatement = @{ operatingCashFlow = 450000; investingCashFlow = -200000; financingCashFlow = -150000; netCashFlow = 100000 }
            loans = @(
                @{ lender = $InstitutionName; loanAmount = 50000; outstandingBalance = 32000; interestRate = 12.5; nextPaymentDate = (Get-Date).AddDays(14).ToString('o') }
            )
        }
        'collateral.json' = @{
            collateralAssets = @(
                @{ id = "COL-$code-001"; assetType = 'Vehicle'; assetDescription = "$InstitutionName delivery vehicle"; currentMarketValue = 200000; isEncumbered = $false; isInsured = $true }
            )
            propertyAndLandData = @(
                @{ id = "PROP-$code-001"; propertyType = 'Commercial'; titleDeedNumber = "$code/5678/2015"; propertyValue = 180000; isEncumbered = $false }
            )
        }
        'animal_data.json' = @{
            animalGroups = @(
                @{ species = 'Dairy Cattle'; breed = 'Friesian'; totalCount = 35; adults = 28; youngStock = 7; averageWeight = 550 }
            )
            breedingRecords = @(
                @{ animalId = 'C001'; breedingDate = (Get-Date).AddDays(-30).ToString('o'); expectedBirthDate = (Get-Date).AddDays(210).ToString('o'); sireInfo = 'Premium Bull'; pregnancyStatus = 'Confirmed' }
            )
            cropPlots = @(
                @{ plotId = "P-$code-001"; cropType = 'Maize'; variety = 'Hybrid'; areaHectares = 12.5; plantingDate = (Get-Date).AddDays(-60).ToString('o'); expectedYield = 8.2 }
            )
            harvestHistory = @(
                @{ plotId = "P-$code-001"; harvestDate = (Get-Date).AddDays(-90).ToString('o'); yieldTonsPerHectare = 7.8; totalYield = 97.5; qualityGrade = 'Grade 1' }
            )
        }
        'farming_data.json' = @{
            equipment = @(
                @{ EquipmentId = "EQ-$code-001"; Type = 'Tractor'; Model = 'Massey Ferguson 275'; PurchaseDate = (Get-Date).AddYears(-3).ToString('o'); Value = 1500000; Condition = 'Good' }
            )
            chemicalApplications = @(
                @{ PlotId = "P-$code-001"; ApplicationDate = (Get-Date).AddDays(-15).ToString('o'); ChemicalType = 'Fertilizer'; ProductName = 'NPK 17-17-17'; Quantity = '50kg/ha'; ApplicationMethod = 'Broadcasting' }
            )
            cropMonitoring = @(
                @{ PlotId = "P-$code-001"; MonitoringDate = (Get-Date).AddDays(-7).ToString('o'); GrowthStage = 'Vegetative'; HealthStatus = 'Good'; PestIncidence = 'Low'; DiseaseIncidence = 'None' }
            )
            buildings = @(
                @{ BuildingId = "B-$code-001"; Type = 'Store'; SizeSquareMeters = 150; Capacity = '30 tons'; ConstructionDate = (Get-Date).AddYears(-5).ToString('o'); Condition = 'Good' }
            )
            vaccinations = @(
                @{ AnimalId = 'C001'; VaccinationDate = (Get-Date).AddDays(-30).ToString('o'); VaccineName = 'FMD Vaccine'; Disease = 'Foot and Mouth'; NextDueDate = (Get-Date).AddMonths(6).ToString('o'); AdministeredBy = 'Dr. Kamau' }
            )
        }
        'artisan_services.json' = @{
            profile = @{
                Id = "ART-$code-001"
                BusinessName = "$InstitutionName Tailoring Services"
                TradeType = 'Tailor'
                YearsInBusiness = 5
                WorkshopLocation = "$InstitutionName Workshop"
                IsRegistered = $true
                RegistrationNumber = "REG/$code/001"
                CouncilLicense = "LIC/$code/001"
                NumberOfEmployees = 3
                NumberOfApprentices = 2
                BusinessPhoneNumber = '+260 000 000000'
                BusinessEmail = "info@$Country.sample"
                AverageMonthlyRevenue = 15000
                TargetMarket = 'Local market'
                ServiceOffered = @('Custom Suits','Alterations')
                RecordDate = $today
            }
            toolsAndEquipment = @(
                @{ Id = "EQ-$code-001"; EquipmentName = 'Industrial Sewing Machine'; EquipmentType = 'Sewing Machine'; Condition = 'Good'; PurchaseValue = 8000; CurrentValue = 6000; PurchaseDate = (Get-Date).AddYears(-2).ToString('o'); SerialNumber = "SER-$code-001"; HasOwnershipDocument = $true; OwnershipDocumentType = 'Purchase Receipt'; LastMaintenanceDate = (Get-Date).AddMonths(-3).ToString('o'); MaintenanceFrequency = 'Quarterly'; IsFinanced = $false; FinancierName = ''; OutstandingBalance = 0; RecordDate = $today }
            )
            rawMaterials = @(
                @{ Id = "MAT-$code-001"; MaterialName = 'Cotton Fabric'; MaterialType = 'Fabric'; Quantity = 150; Unit = 'Meters'; UnitCost = 45; TotalValue = 6750; PurchaseDate = (Get-Date).AddDays(-15).ToString('o'); SupplierName = "$InstitutionName Supplier"; SupplierContact = '+260 000 000001'; StorageLocation = 'Workshop'; MonthlyConsumptionRate = 80; DaysOfInventory = 56; RecordDate = $today }
            )
            orders = @(
                @{ Id = "ORD-$code-001"; OrderNumber = "ORD-$code-001"; CustomerName = "$InstitutionName Customer"; CustomerContact = '+260 000 000002'; ProductOrService = 'Uniforms'; Description = 'Sample order'; OrderValue = 45000; DepositReceived = 22500; BalanceOutstanding = 22500; OrderDate = (Get-Date).AddDays(-30).ToString('o'); ExpectedDeliveryDate = (Get-Date).AddDays(15).ToString('o'); OrderStatus = 'In Progress'; IsContractSigned = $true; PaymentTerms = '50% deposit'; IsRepeatCustomer = $true; RecordDate = $today }
            )
            certifications = @(
                @{ Id = "CERT-$code-001"; CertificateName = 'Master Tailor Certification'; CertificateType = 'TEVETA'; IssuingAuthority = 'TEVETA'; CertificateNumber = "CERT/$code/001"; IssueDate = (Get-Date).AddYears(-4).ToString('o'); ExpiryDate = $null; IsStillValid = $true; SkillLevel = 'Master'; TrainingInstitution = 'Skills Centre'; TrainingDurationMonths = 24; HasPhysicalCertificate = $true; VerificationMethod = 'Portal'; RecordDate = $today }
            )
        }
        'mining_operations.json' = @{
            miningOperations = @{
                ExtractionRate = 1500
                ProcessingCapacity = 2000
                EquipmentUtilization = 85
                Equipment = @(
                    @{ Type = 'Excavator'; Count = 5; Value = 2500000 },
                    @{ Type = 'Truck'; Count = 10; Value = 1500000 }
                )
            }
        }
        'investor_marketplace.json' = @{
            projects = @(
                @{ id = 1; title = "$InstitutionName Growth Project"; sector = 'General'; requiredInvestment = 35000; isVerified = $true; location = $Country; createdDate = (Get-Date).AddMonths(-3).ToString('o') }
            )
            investmentRanges = @(
                @{ label = 'Under 50k'; value = '0-50000'; minValue = 0; maxValue = 50000 },
                @{ label = '50k to 250k'; value = '50000-250000'; minValue = 50000; maxValue = 250000 }
            )
        }
        'energy_projects.json' = @{ projects = @(@{ id = "EN-$code-001"; title = 'Solar Irrigation Expansion'; location = $Country; requiredInvestment = 120000; verified = $true }) }
        'climate_finance.json' = @{ projects = @(@{ id = "CF-$code-001"; title = 'Climate Smart Agriculture Program'; location = $Country; requiredInvestment = 85000; verified = $true }) }
        'carbon_projects.json' = @{ projects = @(@{ id = "CARB-$code-001"; title = 'Agroforestry Carbon Sequestration'; location = $Country; requiredInvestment = 90000; verified = $true }) }
        'infrastructure_projects.json' = @{ projects = @(@{ id = "INF-$code-001"; title = 'Cold Storage Network'; location = $Country; requiredInvestment = 250000; verified = $true }) }
        'loans.json' = @{ loans = @(@{ loanId = "LN-$code-001"; borrower = "$InstitutionName Borrower"; amount = 50000; balance = 32000; interestRate = 12.5; nextPaymentDate = (Get-Date).AddDays(14).ToString('o') }) }
        'monitoring_history.json' = @{ items = @(@{ businessId = "SB-$code-001"; month = '2026-03'; utilization = 62; repayment = 81; riskScore = 29 }) }
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

            $payload = Get-BasePayload -Country $country -InstitutionType $institutionType -InstitutionName $institutionName
            foreach ($file in $standardFiles) {
                Write-JsonFile -Path (Join-Path $folder $file) -Value $payload[$file]
            }
        }
    }
}

Write-Host 'Sample data generated successfully.'
