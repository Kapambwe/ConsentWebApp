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
    return ($Value.Trim().ToLowerInvariant() -replace '[^a-z0-9]+', '-').Trim('-')
}

function Get-Context {
    param(
        [string]$Country,
        [string]$InstitutionType,
        [string]$Institution
    )

    $cleanCountry = Normalize-Key $Country
    $cleanType = Normalize-Key $InstitutionType
    $cleanInstitution = Normalize-Key $Institution

    $displayInstitution = (($cleanInstitution -split '-') | ForEach-Object {
        if ($_ -match '^[a-z]') { $_.Substring(0,1).ToUpperInvariant() + $_.Substring(1) } else { $_ }
    }) -join ' '

    switch ($cleanCountry) {
        'zambia' {
            if ($cleanInstitution -eq 'absa-bank-zambia') {
                return @{
                    Country = 'Zambia'
                    CountryCode = 'ZM'
                    Currency = 'ZMW'
                    Capital = 'Lusaka'
                    InstitutionName = 'Absa Bank Zambia'
                    InstitutionType = 'bank'
                    BusinessName = 'Absa Bank Zambia SME Desk'
                    Sector = 'Banking'
                    Regulator = 'Bank of Zambia'
                    TaxAuthority = 'ZRA'
                    ProofIssuer = 'ZRA'
                    ProvincialLocation = 'Lusaka Province'
                    Requests = @(
                        @{ Id = 'REQ-ZM-001'; SubjectName = 'Kafue Agricultural Cooperative'; PurposeTemplate = 'Agricultural Loan Assessment'; Status = 'Pending' },
                        @{ Id = 'REQ-ZM-002'; SubjectName = 'Lusaka Tailoring Cooperative'; PurposeTemplate = 'Working Capital Review'; Status = 'Granted' },
                        @{ Id = 'REQ-ZM-003'; SubjectName = 'Siavonga Fish Farmers'; PurposeTemplate = 'Asset Finance Review'; Status = 'Pending' },
                        @{ Id = 'REQ-ZM-004'; SubjectName = 'Copperbelt Small Miners Group'; PurposeTemplate = 'Equipment Finance Review'; Status = 'Denied' },
                        @{ Id = 'REQ-ZM-005'; SubjectName = 'Kabwe Furniture Makers'; PurposeTemplate = 'Order Book Review'; Status = 'Withdrawn' }
                    )
                    Businesses = @(
                        @{ Id = 'SB-ZM-001'; BusinessName = 'Lusaka Tailoring Cooperative'; Sector = 'Clothing Manufacturing'; LoanAmount = 35000; UseOfFunds = 54; RepaymentScore = 82; RiskScore = 28; Status = 'Funded' },
                        @{ Id = 'SB-ZM-002'; BusinessName = 'Kabwe Furniture Makers'; Sector = 'Furniture Manufacturing'; LoanAmount = 42000; UseOfFunds = 68; RepaymentScore = 79; RiskScore = 31; Status = 'Funded' },
                        @{ Id = 'SB-ZM-003'; BusinessName = 'Siavonga Fish Farming Cooperative'; Sector = 'Aquaculture'; LoanAmount = 48000; UseOfFunds = 61; RepaymentScore = 77; RiskScore = 34; Status = 'Funded' }
                    )
                }
            }

            switch ($cleanInstitution) {
                'zambia-commercial-bank' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Zambia Commercial Bank'
                        InstitutionType = 'bank'
                        BusinessName = 'Zambia Commercial Bank SME Desk'
                        Sector = 'Commercial Banking'
                        Regulator = 'Bank of Zambia'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'ZRA'
                        ProvincialLocation = 'Central Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-ZCB-001'; SubjectName = 'Chisamba Dairy Cooperative'; PurposeTemplate = 'Livestock Loan Assessment'; Status = 'Pending' },
                            @{ Id = 'REQ-ZM-ZCB-002'; SubjectName = 'Ndola Grain Traders'; PurposeTemplate = 'Trade Finance Review'; Status = 'Granted' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-ZCB-001'; BusinessName = 'Chisamba Dairy Cooperative'; Sector = 'Dairy Farming'; LoanAmount = 58000; UseOfFunds = 72; RepaymentScore = 84; RiskScore = 25; Status = 'Funded' }
                        )
                    }
                }
                'lusaka-capital-partners' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Lusaka Capital Partners'
                        InstitutionType = 'investment-bank'
                        BusinessName = 'Lusaka Capital Partners Advisory'
                        Sector = 'Investment Banking'
                        Regulator = 'Securities and Exchange Commission'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'ZRA'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-LCP-001'; SubjectName = 'Copperbelt Growth Fund'; PurposeTemplate = 'Investment Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-LCP-001'; BusinessName = 'Copperbelt Growth Fund'; Sector = 'Investment Services'; LoanAmount = 250000; UseOfFunds = 70; RepaymentScore = 85; RiskScore = 20; Status = 'Funded' }
                        )
                    }
                }
                'indeco-investment-bank' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'INDECO Investment Bank'
                        InstitutionType = 'investment-bank'
                        BusinessName = 'INDECO Project Finance'
                        Sector = 'Investment Banking'
                        Regulator = 'Securities and Exchange Commission'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'ZRA'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-INDECO-001'; SubjectName = 'Energy Infrastructure SPV'; PurposeTemplate = 'Project Finance Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-INDECO-001'; BusinessName = 'Energy Infrastructure SPV'; Sector = 'Infrastructure'; LoanAmount = 500000; UseOfFunds = 73; RepaymentScore = 84; RiskScore = 21; Status = 'Funded' }
                        )
                    }
                }
                'zambia-wealth-management' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Zambia Wealth Management'
                        InstitutionType = 'mutual-fund'
                        BusinessName = 'Zambia Wealth Management Desk'
                        Sector = 'Asset Management'
                        Regulator = 'Securities and Exchange Commission'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'ZRA'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-ZWM-001'; SubjectName = 'High Net Worth Portfolio'; PurposeTemplate = 'Portfolio Review'; Status = 'Granted' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-ZWM-001'; BusinessName = 'High Net Worth Portfolio'; Sector = 'Asset Management'; LoanAmount = 150000; UseOfFunds = 50; RepaymentScore = 88; RiskScore = 18; Status = 'Funded' }
                        )
                    }
                }
                'capital-growth-fund' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Capital Growth Fund'
                        InstitutionType = 'mutual-fund'
                        BusinessName = 'Capital Growth Fund Desk'
                        Sector = 'Asset Management'
                        Regulator = 'Securities and Exchange Commission'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'ZRA'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-CGF-001'; SubjectName = 'Growth Portfolio Client'; PurposeTemplate = 'Investment Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-CGF-001'; BusinessName = 'Growth Portfolio Client'; Sector = 'Wealth Management'; LoanAmount = 200000; UseOfFunds = 52; RepaymentScore = 86; RiskScore = 19; Status = 'Funded' }
                        )
                    }
                }
                'agri-loan-microfinance' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Agri Loan Microfinance'
                        InstitutionType = 'micro-finance'
                        BusinessName = 'Agri Loan Microfinance Desk'
                        Sector = 'Micro Finance'
                        Regulator = 'Bank of Zambia'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'ZRA'
                        ProvincialLocation = 'Central Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-ALM-001'; SubjectName = 'Chisamba Market Gardeners'; PurposeTemplate = 'Seasonal Working Capital'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-ALM-001'; BusinessName = 'Chisamba Market Gardeners'; Sector = 'Smallholder Farming'; LoanAmount = 12000; UseOfFunds = 59; RepaymentScore = 75; RiskScore = 32; Status = 'Funded' }
                        )
                    }
                }
                'community-savings-zambia' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Community Savings Zambia'
                        InstitutionType = 'micro-finance'
                        BusinessName = 'Community Savings Zambia Desk'
                        Sector = 'Micro Finance'
                        Regulator = 'Bank of Zambia'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'ZRA'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-CSZ-001'; SubjectName = 'Peri-Urban Women Traders'; PurposeTemplate = 'Group Lending Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-CSZ-001'; BusinessName = 'Peri-Urban Women Traders'; Sector = 'Retail Trade'; LoanAmount = 8000; UseOfFunds = 62; RepaymentScore = 77; RiskScore = 30; Status = 'Funded' }
                        )
                    }
                }
                'banda-smallholdings' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Banda Smallholdings'
                        InstitutionType = 'farmer'
                        BusinessName = 'Banda Smallholdings'
                        Sector = 'Agriculture'
                        Regulator = 'Ministry of Agriculture'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Ministry of Agriculture'
                        ProvincialLocation = 'Central Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-FARM-001'; SubjectName = 'Banda Smallholdings'; PurposeTemplate = 'Farm Expansion Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-FARM-001'; BusinessName = 'Banda Smallholdings'; Sector = 'Crop Farming'; LoanAmount = 30000; UseOfFunds = 64; RepaymentScore = 78; RiskScore = 28; Status = 'Funded' }
                        )
                    }
                }
                'agri-aid-international' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Agri Aid International'
                        InstitutionType = 'ngo'
                        BusinessName = 'Agri Aid International Projects'
                        Sector = 'NGO'
                        Regulator = 'Registrar of NGOs'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Registrar of NGOs'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-NGO-001'; SubjectName = 'Women Farmers Group'; PurposeTemplate = 'Grant Review'; Status = 'Granted' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-NGO-001'; BusinessName = 'Women Farmers Group'; Sector = 'Community Development'; LoanAmount = 15000; UseOfFunds = 49; RepaymentScore = 89; RiskScore = 16; Status = 'Funded' }
                        )
                    }
                }
                'ministry-of-finance' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Ministry of Finance'
                        InstitutionType = 'government'
                        BusinessName = 'Ministry of Finance'
                        Sector = 'Public Sector'
                        Regulator = 'Government of Zambia'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Government of Zambia'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-GOV-001'; SubjectName = 'Public Infrastructure SPV'; PurposeTemplate = 'Budget Support Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-GOV-001'; BusinessName = 'Public Infrastructure SPV'; Sector = 'Infrastructure'; LoanAmount = 600000; UseOfFunds = 70; RepaymentScore = 83; RiskScore = 20; Status = 'Funded' }
                        )
                    }
                }
                'bank-of-zambia' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Bank of Zambia'
                        InstitutionType = 'government'
                        BusinessName = 'Bank of Zambia Supervision'
                        Sector = 'Monetary Authority'
                        Regulator = 'Government of Zambia'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Government of Zambia'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-BOZ-001'; SubjectName = 'Financial Institution Review'; PurposeTemplate = 'Compliance Review'; Status = 'Granted' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-BOZ-001'; BusinessName = 'Financial Institution Review'; Sector = 'Financial Services'; LoanAmount = 100000; UseOfFunds = 40; RepaymentScore = 95; RiskScore = 10; Status = 'Funded' }
                        )
                    }
                }
            }

            switch ($cleanType) {
                'insurance' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = $displayInstitution
                        InstitutionType = 'insurance'
                        BusinessName = "$displayInstitution Insurance Desk"
                        Sector = 'Insurance'
                        Regulator = 'Pensions and Insurance Authority'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Pensions and Insurance Authority'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = "REQ-ZM-INS-$cleanInstitution-001"; SubjectName = "$displayInstitution Policyholder Group"; PurposeTemplate = 'Policy Underwriting'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = "SB-ZM-INS-$cleanInstitution-001"; BusinessName = "$displayInstitution Policyholder Group"; Sector = 'Insurance'; LoanAmount = 22000; UseOfFunds = 46; RepaymentScore = 74; RiskScore = 22; Status = 'Funded' }
                        )
                    }
                }
                'government' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = $displayInstitution
                        InstitutionType = 'government'
                        BusinessName = "$displayInstitution Public Desk"
                        Sector = 'Public Sector'
                        Regulator = 'Government of Zambia'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Government of Zambia'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = "REQ-ZM-GOV-$cleanInstitution-001"; SubjectName = "$displayInstitution Department"; PurposeTemplate = 'Public Finance Review'; Status = 'Granted' }
                        )
                        Businesses = @(
                            @{ Id = "SB-ZM-GOV-$cleanInstitution-001"; BusinessName = "$displayInstitution Department"; Sector = 'Public Administration'; LoanAmount = 80000; UseOfFunds = 42; RepaymentScore = 92; RiskScore = 12; Status = 'Funded' }
                        )
                    }
                }
                'farmer' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = $displayInstitution
                        InstitutionType = 'farmer'
                        BusinessName = "$displayInstitution Farm Desk"
                        Sector = 'Agriculture'
                        Regulator = 'Ministry of Agriculture'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Ministry of Agriculture'
                        ProvincialLocation = 'Central Province'
                        Requests = @(
                            @{ Id = "REQ-ZM-FARM-$cleanInstitution-001"; SubjectName = "$displayInstitution Farmers Group"; PurposeTemplate = 'Crop Finance Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = "SB-ZM-FARM-$cleanInstitution-001"; BusinessName = "$displayInstitution Farmers Group"; Sector = 'Agriculture'; LoanAmount = 28000; UseOfFunds = 63; RepaymentScore = 78; RiskScore = 29; Status = 'Funded' }
                        )
                    }
                }
                'ngo' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = $displayInstitution
                        InstitutionType = 'ngo'
                        BusinessName = "$displayInstitution Projects"
                        Sector = 'NGO'
                        Regulator = 'Registrar of NGOs'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Registrar of NGOs'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = "REQ-ZM-NGO-$cleanInstitution-001"; SubjectName = "$displayInstitution Project Group"; PurposeTemplate = 'Grant Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = "SB-ZM-NGO-$cleanInstitution-001"; BusinessName = "$displayInstitution Project Group"; Sector = 'Community Development'; LoanAmount = 15000; UseOfFunds = 50; RepaymentScore = 88; RiskScore = 18; Status = 'Funded' }
                        )
                    }
                }
                'micro-finance' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = $displayInstitution
                        InstitutionType = 'micro-finance'
                        BusinessName = "$displayInstitution Micro Desk"
                        Sector = 'Micro Finance'
                        Regulator = 'Bank of Zambia'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'ZRA'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = "REQ-ZM-MF-$cleanInstitution-001"; SubjectName = "$displayInstitution Market Traders"; PurposeTemplate = 'Group Lending Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = "SB-ZM-MF-$cleanInstitution-001"; BusinessName = "$displayInstitution Market Traders"; Sector = 'Retail Trade'; LoanAmount = 9000; UseOfFunds = 60; RepaymentScore = 76; RiskScore = 31; Status = 'Funded' }
                        )
                    }
                }
                'government-agency' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = $displayInstitution
                        InstitutionType = 'government-agency'
                        BusinessName = "$displayInstitution Agency Desk"
                        Sector = 'Development Finance'
                        Regulator = 'Government of Zambia'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Government of Zambia'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = "REQ-ZM-GA-$cleanInstitution-001"; SubjectName = "$displayInstitution Beneficiary"; PurposeTemplate = 'Grant Review'; Status = 'Granted' }
                        )
                        Businesses = @(
                            @{ Id = "SB-ZM-GA-$cleanInstitution-001"; BusinessName = "$displayInstitution Beneficiary"; Sector = 'Development'; LoanAmount = 20000; UseOfFunds = 48; RepaymentScore = 90; RiskScore = 14; Status = 'Funded' }
                        )
                    }
                }
            }

            switch ($cleanInstitution) {
                'stanbic-bank' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Stanbic Bank Zambia'
                        InstitutionType = 'bank'
                        BusinessName = 'Stanbic Bank Zambia Business Desk'
                        Sector = 'Corporate Banking'
                        Regulator = 'Bank of Zambia'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'ZRA'
                        ProvincialLocation = 'Copperbelt Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-SB-001'; SubjectName = 'Kitwe Shoe Makers'; PurposeTemplate = 'Equipment Finance Review'; Status = 'Pending' },
                            @{ Id = 'REQ-ZM-SB-002'; SubjectName = 'Mufulira Mining Services'; PurposeTemplate = 'Working Capital Review'; Status = 'Granted' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-SB-001'; BusinessName = 'Kitwe Shoe Makers'; Sector = 'Footwear Manufacturing'; LoanAmount = 48000; UseOfFunds = 66; RepaymentScore = 80; RiskScore = 29; Status = 'Funded' }
                        )
                    }
                }
                'protect-insurance' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Protect Insurance'
                        InstitutionType = 'insurance'
                        BusinessName = 'Protect Insurance Underwriting'
                        Sector = 'Insurance'
                        Regulator = 'Pensions and Insurance Authority'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Pensions and Insurance Authority'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-INS-001'; SubjectName = 'Kafue Transport Fleet'; PurposeTemplate = 'Motor Insurance Review'; Status = 'Pending' },
                            @{ Id = 'REQ-ZM-INS-002'; SubjectName = 'Lusaka Tailoring Cooperative'; PurposeTemplate = 'Asset Insurance Review'; Status = 'Granted' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-INS-001'; BusinessName = 'Kafue Transport Fleet'; Sector = 'Logistics'; LoanAmount = 25000; UseOfFunds = 44; RepaymentScore = 76; RiskScore = 22; Status = 'Funded' }
                        )
                    }
                }
                'madison-insurance' {
                    return @{
                        Country = 'Zambia'
                        CountryCode = 'ZM'
                        Currency = 'ZMW'
                        Capital = 'Lusaka'
                        InstitutionName = 'Madison Insurance'
                        InstitutionType = 'insurance'
                        BusinessName = 'Madison Insurance Claims Desk'
                        Sector = 'Insurance'
                        Regulator = 'Pensions and Insurance Authority'
                        TaxAuthority = 'ZRA'
                        ProofIssuer = 'Pensions and Insurance Authority'
                        ProvincialLocation = 'Lusaka Province'
                        Requests = @(
                            @{ Id = 'REQ-ZM-MAD-001'; SubjectName = 'Mongu Rice Growers'; PurposeTemplate = 'Crop Insurance Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZM-MAD-001'; BusinessName = 'Mongu Rice Growers'; Sector = 'Agriculture'; LoanAmount = 32000; UseOfFunds = 57; RepaymentScore = 75; RiskScore = 26; Status = 'Funded' }
                        )
                    }
                }
            }

            return @{
                Country = 'Zambia'
                CountryCode = 'ZM'
                Currency = 'ZMW'
                Capital = 'Lusaka'
                InstitutionName = $displayInstitution
                InstitutionType = $cleanType
                BusinessName = "$displayInstitution SME Desk"
                Sector = switch ($cleanType) {
                    'insurance' { 'Insurance' }
                    'government' { 'Public Sector' }
                    'farmer' { 'Agriculture' }
                    'investment-bank' { 'Investment Banking' }
                    'mutual-fund' { 'Asset Management' }
                    'micro-finance' { 'Micro Finance' }
                    'government-agency' { 'Development Finance' }
                    default { 'Banking' }
                }
                Regulator = 'Bank of Zambia'
                TaxAuthority = 'ZRA'
                ProofIssuer = 'ZRA'
                ProvincialLocation = 'Lusaka Province'
                Requests = @(
                    @{ Id = "REQ-$cleanCountry-$cleanType-001"; SubjectName = "$displayInstitution Trader Group"; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' },
                    @{ Id = "REQ-$cleanCountry-$cleanType-002"; SubjectName = "$displayInstitution Cooperative"; PurposeTemplate = 'Loan Assessment'; Status = 'Granted' }
                )
                Businesses = @(
                    @{ Id = "SB-$cleanCountry-$cleanType-001"; BusinessName = "$displayInstitution Cooperative"; Sector = 'General Commerce'; LoanAmount = 50000; UseOfFunds = 58; RepaymentScore = 81; RiskScore = 30; Status = 'Funded' }
                )
            }
        }
        'kenya' {
            switch ($cleanInstitution) {
                'kcb-bank' {
                    return @{
                        Country = 'Kenya'
                        CountryCode = 'KE'
                        Currency = 'KES'
                        Capital = 'Nairobi'
                        InstitutionName = 'KCB Bank'
                        InstitutionType = 'bank'
                        BusinessName = 'KCB SME Banking'
                        Sector = 'Commercial Banking'
                        Regulator = 'Central Bank of Kenya'
                        TaxAuthority = 'KRA'
                        ProofIssuer = 'KRA'
                        ProvincialLocation = 'Nairobi County'
                        Requests = @(
                            @{ Id = 'REQ-KE-KCB-001'; SubjectName = 'Kericho Tea Cooperative'; PurposeTemplate = 'Agribusiness Loan Review'; Status = 'Pending' },
                            @{ Id = 'REQ-KE-KCB-002'; SubjectName = 'Mombasa Fish Exporters'; PurposeTemplate = 'Trade Finance Review'; Status = 'Granted' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-KE-KCB-001'; BusinessName = 'Kericho Tea Cooperative'; Sector = 'Agribusiness'; LoanAmount = 72000; UseOfFunds = 65; RepaymentScore = 83; RiskScore = 24; Status = 'Funded' }
                        )
                    }
                }
                'equity-bank' {
                    return @{
                        Country = 'Kenya'
                        CountryCode = 'KE'
                        Currency = 'KES'
                        Capital = 'Nairobi'
                        InstitutionName = 'Equity Bank'
                        InstitutionType = 'bank'
                        BusinessName = 'Equity Bank Business Desk'
                        Sector = 'Retail Banking'
                        Regulator = 'Central Bank of Kenya'
                        TaxAuthority = 'KRA'
                        ProofIssuer = 'KRA'
                        ProvincialLocation = 'Nairobi County'
                        Requests = @(
                            @{ Id = 'REQ-KE-EQ-001'; SubjectName = 'Nakuru Dairy Farmers'; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-KE-EQ-001'; BusinessName = 'Nakuru Dairy Farmers'; Sector = 'Dairy Farming'; LoanAmount = 58000; UseOfFunds = 61; RepaymentScore = 79; RiskScore = 30; Status = 'Funded' }
                        )
                    }
                }
            }

            return @{
                Country = 'Kenya'
                CountryCode = 'KE'
                Currency = 'KES'
                Capital = 'Nairobi'
                InstitutionName = $displayInstitution
                InstitutionType = $cleanType
                BusinessName = "$displayInstitution SME Desk"
                Sector = switch ($cleanType) {
                    'private-investor' { 'Private Capital' }
                    'insurance' { 'Insurance' }
                    'pension-fund' { 'Pension Management' }
                    default { 'Banking' }
                }
                Regulator = 'Central Bank of Kenya'
                TaxAuthority = 'KRA'
                ProofIssuer = 'KRA'
                ProvincialLocation = 'Nairobi County'
                Requests = @(
                    @{ Id = "REQ-KE-$cleanType-001"; SubjectName = "$displayInstitution Tea Cooperative"; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' },
                    @{ Id = "REQ-KE-$cleanType-002"; SubjectName = "$displayInstitution Market Traders"; PurposeTemplate = 'Business Expansion Review'; Status = 'Granted' }
                )
                Businesses = @(
                    @{ Id = "SB-KE-$cleanType-001"; BusinessName = "$displayInstitution Tea Cooperative"; Sector = 'Agribusiness'; LoanAmount = 64000; UseOfFunds = 63; RepaymentScore = 78; RiskScore = 33; Status = 'Funded' }
                )
            }
        }
        'south-africa' {
            switch ($cleanInstitution) {
                'standard-bank' {
                    return @{
                        Country = 'South Africa'
                        CountryCode = 'ZA'
                        Currency = 'ZAR'
                        Capital = 'Pretoria'
                        InstitutionName = 'Standard Bank'
                        InstitutionType = 'bank'
                        BusinessName = 'Standard Bank SME Desk'
                        Sector = 'Commercial Banking'
                        Regulator = 'South African Reserve Bank'
                        TaxAuthority = 'SARS'
                        ProofIssuer = 'SARS'
                        ProvincialLocation = 'Gauteng'
                        Requests = @(
                            @{ Id = 'REQ-ZA-SB-001'; SubjectName = 'Soweto Logistics Fleet'; PurposeTemplate = 'Asset Finance Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZA-SB-001'; BusinessName = 'Soweto Logistics Fleet'; Sector = 'Logistics'; LoanAmount = 130000; UseOfFunds = 71; RepaymentScore = 82; RiskScore = 26; Status = 'Funded' }
                        )
                    }
                }
                'fnb-south-africa' {
                    return @{
                        Country = 'South Africa'
                        CountryCode = 'ZA'
                        Currency = 'ZAR'
                        Capital = 'Pretoria'
                        InstitutionName = 'FNB South Africa'
                        InstitutionType = 'bank'
                        BusinessName = 'FNB Business Banking'
                        Sector = 'Commercial Banking'
                        Regulator = 'South African Reserve Bank'
                        TaxAuthority = 'SARS'
                        ProofIssuer = 'SARS'
                        ProvincialLocation = 'Western Cape'
                        Requests = @(
                            @{ Id = 'REQ-ZA-FNB-001'; SubjectName = 'Cape Town Hospitality Group'; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZA-FNB-001'; BusinessName = 'Cape Town Hospitality Group'; Sector = 'Hospitality'; LoanAmount = 110000; UseOfFunds = 67; RepaymentScore = 81; RiskScore = 28; Status = 'Funded' }
                        )
                    }
                }
                'nedbank' {
                    return @{
                        Country = 'South Africa'
                        CountryCode = 'ZA'
                        Currency = 'ZAR'
                        Capital = 'Pretoria'
                        InstitutionName = 'Nedbank'
                        InstitutionType = 'bank'
                        BusinessName = 'Nedbank SME Desk'
                        Sector = 'Commercial Banking'
                        Regulator = 'South African Reserve Bank'
                        TaxAuthority = 'SARS'
                        ProofIssuer = 'SARS'
                        ProvincialLocation = 'KwaZulu-Natal'
                        Requests = @(
                            @{ Id = 'REQ-ZA-NED-001'; SubjectName = 'Durban Retail Traders'; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZA-NED-001'; BusinessName = 'Durban Retail Traders'; Sector = 'Retail'; LoanAmount = 90000; UseOfFunds = 63; RepaymentScore = 79; RiskScore = 30; Status = 'Funded' }
                        )
                    }
                }
                'absa-group' {
                    return @{
                        Country = 'South Africa'
                        CountryCode = 'ZA'
                        Currency = 'ZAR'
                        Capital = 'Pretoria'
                        InstitutionName = 'Absa Group'
                        InstitutionType = 'bank'
                        BusinessName = 'Absa Business Banking'
                        Sector = 'Commercial Banking'
                        Regulator = 'South African Reserve Bank'
                        TaxAuthority = 'SARS'
                        ProofIssuer = 'SARS'
                        ProvincialLocation = 'Gauteng'
                        Requests = @(
                            @{ Id = 'REQ-ZA-ABSA-001'; SubjectName = 'Pretoria Construction Supplies'; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZA-ABSA-001'; BusinessName = 'Pretoria Construction Supplies'; Sector = 'Construction Supply'; LoanAmount = 155000; UseOfFunds = 74; RepaymentScore = 81; RiskScore = 25; Status = 'Funded' }
                        )
                    }
                }
                'investec-sa' {
                    return @{
                        Country = 'South Africa'
                        CountryCode = 'ZA'
                        Currency = 'ZAR'
                        Capital = 'Pretoria'
                        InstitutionName = 'Investec SA'
                        InstitutionType = 'investment-bank'
                        BusinessName = 'Investec SA Advisory'
                        Sector = 'Investment Banking'
                        Regulator = 'South African Reserve Bank'
                        TaxAuthority = 'SARS'
                        ProofIssuer = 'SARS'
                        ProvincialLocation = 'Gauteng'
                        Requests = @(
                            @{ Id = 'REQ-ZA-IV-001'; SubjectName = 'Johannesburg Growth Fund'; PurposeTemplate = 'Investment Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZA-IV-001'; BusinessName = 'Johannesburg Growth Fund'; Sector = 'Investment Services'; LoanAmount = 200000; UseOfFunds = 69; RepaymentScore = 84; RiskScore = 22; Status = 'Funded' }
                        )
                    }
                }
                'rand-merchant-bank' {
                    return @{
                        Country = 'South Africa'
                        CountryCode = 'ZA'
                        Currency = 'ZAR'
                        Capital = 'Pretoria'
                        InstitutionName = 'Rand Merchant Bank'
                        InstitutionType = 'investment-bank'
                        BusinessName = 'Rand Merchant Advisory'
                        Sector = 'Investment Banking'
                        Regulator = 'South African Reserve Bank'
                        TaxAuthority = 'SARS'
                        ProofIssuer = 'SARS'
                        ProvincialLocation = 'Gauteng'
                        Requests = @(
                            @{ Id = 'REQ-ZA-RMB-001'; SubjectName = 'Mining Growth SPV'; PurposeTemplate = 'Project Finance Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZA-RMB-001'; BusinessName = 'Mining Growth SPV'; Sector = 'Mining Services'; LoanAmount = 260000; UseOfFunds = 72; RepaymentScore = 85; RiskScore = 21; Status = 'Funded' }
                        )
                    }
                }
                'old-mutual' {
                    return @{
                        Country = 'South Africa'
                        CountryCode = 'ZA'
                        Currency = 'ZAR'
                        Capital = 'Pretoria'
                        InstitutionName = 'Old Mutual'
                        InstitutionType = 'insurance'
                        BusinessName = 'Old Mutual Underwriting'
                        Sector = 'Insurance'
                        Regulator = 'FSCA'
                        TaxAuthority = 'SARS'
                        ProofIssuer = 'FSCA'
                        ProvincialLocation = 'Western Cape'
                        Requests = @(
                            @{ Id = 'REQ-ZA-OM-001'; SubjectName = 'Farm Asset Portfolio'; PurposeTemplate = 'Asset Insurance Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZA-OM-001'; BusinessName = 'Farm Asset Portfolio'; Sector = 'Agriculture'; LoanAmount = 50000; UseOfFunds = 45; RepaymentScore = 78; RiskScore = 23; Status = 'Funded' }
                        )
                    }
                }
                'discovery-limited' {
                    return @{
                        Country = 'South Africa'
                        CountryCode = 'ZA'
                        Currency = 'ZAR'
                        Capital = 'Pretoria'
                        InstitutionName = 'Discovery Limited'
                        InstitutionType = 'insurance'
                        BusinessName = 'Discovery Insurance'
                        Sector = 'Insurance'
                        Regulator = 'FSCA'
                        TaxAuthority = 'SARS'
                        ProofIssuer = 'FSCA'
                        ProvincialLocation = 'Gauteng'
                        Requests = @(
                            @{ Id = 'REQ-ZA-DIS-001'; SubjectName = 'Fleet Insurance Portfolio'; PurposeTemplate = 'Motor Insurance Review'; Status = 'Pending' }
                        )
                        Businesses = @(
                            @{ Id = 'SB-ZA-DIS-001'; BusinessName = 'Fleet Insurance Portfolio'; Sector = 'Logistics'; LoanAmount = 70000; UseOfFunds = 43; RepaymentScore = 77; RiskScore = 24; Status = 'Funded' }
                        )
                    }
                }
            }

            return @{
                Country = 'South Africa'
                CountryCode = 'ZA'
                Currency = 'ZAR'
                Capital = 'Pretoria'
                InstitutionName = $displayInstitution
                InstitutionType = $cleanType
                BusinessName = "$displayInstitution Commercial Desk"
                Sector = switch ($cleanType) {
                    'insurance' { 'Insurance' }
                    'private-investor' { 'Private Equity' }
                    'investment-bank' { 'Investment Banking' }
                    'government' { 'Public Finance' }
                    default { 'Banking' }
                }
                Regulator = 'South African Reserve Bank'
                TaxAuthority = 'SARS'
                ProofIssuer = 'SARS'
                ProvincialLocation = 'Gauteng'
                Requests = @(
                    @{ Id = "REQ-ZA-$cleanType-001"; SubjectName = "$displayInstitution Enterprise"; PurposeTemplate = 'Growth Capital Review'; Status = 'Pending' },
                    @{ Id = "REQ-ZA-$cleanType-002"; SubjectName = "$displayInstitution Cooperative"; PurposeTemplate = 'Trade Finance Review'; Status = 'Granted' }
                )
                Businesses = @(
                    @{ Id = "SB-ZA-$cleanType-001"; BusinessName = "$displayInstitution Enterprise"; Sector = 'Industrial Services'; LoanAmount = 120000; UseOfFunds = 69; RepaymentScore = 80; RiskScore = 27; Status = 'Funded' }
                )
            }
        }
        default {
            if ($cleanCountry -eq 'nigeria') {
                switch ($cleanInstitution) {
                    'access-bank' {
                        return @{
                            Country = 'Nigeria'
                            CountryCode = 'NG'
                            Currency = 'NGN'
                            Capital = 'Abuja'
                            InstitutionName = 'Access Bank'
                            InstitutionType = 'bank'
                            BusinessName = 'Access Bank SME Desk'
                            Sector = 'Commercial Banking'
                            Regulator = 'Central Bank of Nigeria'
                            TaxAuthority = 'FIRS'
                            ProofIssuer = 'FIRS'
                            ProvincialLocation = 'Lagos State'
                            Requests = @(
                                @{ Id = 'REQ-NG-ACC-001'; SubjectName = 'Lagos Agro Traders'; PurposeTemplate = 'Trade Finance Review'; Status = 'Pending' }
                            )
                            Businesses = @(
                                @{ Id = 'SB-NG-ACC-001'; BusinessName = 'Lagos Agro Traders'; Sector = 'Agribusiness'; LoanAmount = 4500000; UseOfFunds = 67; RepaymentScore = 78; RiskScore = 29; Status = 'Funded' }
                            )
                        }
                    }
                    'zenith-bank' {
                        return @{
                            Country = 'Nigeria'
                            CountryCode = 'NG'
                            Currency = 'NGN'
                            Capital = 'Abuja'
                            InstitutionName = 'Zenith Bank'
                            InstitutionType = 'bank'
                            BusinessName = 'Zenith Bank Business Desk'
                            Sector = 'Commercial Banking'
                            Regulator = 'Central Bank of Nigeria'
                            TaxAuthority = 'FIRS'
                            ProofIssuer = 'FIRS'
                            ProvincialLocation = 'Lagos State'
                            Requests = @(
                                @{ Id = 'REQ-NG-ZEN-001'; SubjectName = 'Abuja Construction Suppliers'; PurposeTemplate = 'Asset Finance Review'; Status = 'Pending' }
                            )
                            Businesses = @(
                                @{ Id = 'SB-NG-ZEN-001'; BusinessName = 'Abuja Construction Suppliers'; Sector = 'Construction Supply'; LoanAmount = 5200000; UseOfFunds = 70; RepaymentScore = 80; RiskScore = 27; Status = 'Funded' }
                            )
                        }
                    }
                    'leadway-assurance' {
                        return @{
                            Country = 'Nigeria'
                            CountryCode = 'NG'
                            Currency = 'NGN'
                            Capital = 'Abuja'
                            InstitutionName = 'Leadway Assurance'
                            InstitutionType = 'insurance'
                            BusinessName = 'Leadway Underwriting'
                            Sector = 'Insurance'
                            Regulator = 'National Insurance Commission'
                            TaxAuthority = 'FIRS'
                            ProofIssuer = 'National Insurance Commission'
                            ProvincialLocation = 'Lagos State'
                            Requests = @(
                                @{ Id = 'REQ-NG-LW-001'; SubjectName = 'Logistics Fleet Portfolio'; PurposeTemplate = 'Motor Insurance Review'; Status = 'Pending' }
                            )
                            Businesses = @(
                                @{ Id = 'SB-NG-LW-001'; BusinessName = 'Logistics Fleet Portfolio'; Sector = 'Logistics'; LoanAmount = 3000000; UseOfFunds = 45; RepaymentScore = 77; RiskScore = 26; Status = 'Funded' }
                            )
                        }
                    }
                    'central-bank-of-nigeria' {
                        return @{
                            Country = 'Nigeria'
                            CountryCode = 'NG'
                            Currency = 'NGN'
                            Capital = 'Abuja'
                            InstitutionName = 'Central Bank of Nigeria'
                            InstitutionType = 'government'
                            BusinessName = 'Central Bank of Nigeria'
                            Sector = 'Monetary Authority'
                            Regulator = 'Federal Government of Nigeria'
                            TaxAuthority = 'FIRS'
                            ProofIssuer = 'Federal Government of Nigeria'
                            ProvincialLocation = 'Abuja'
                            Requests = @(
                                @{ Id = 'REQ-NG-CBN-001'; SubjectName = 'Financial Sector Review'; PurposeTemplate = 'Regulatory Review'; Status = 'Granted' }
                            )
                            Businesses = @(
                                @{ Id = 'SB-NG-CBN-001'; BusinessName = 'Financial Sector Review'; Sector = 'Financial Services'; LoanAmount = 10000000; UseOfFunds = 35; RepaymentScore = 96; RiskScore = 8; Status = 'Funded' }
                            )
                        }
                    }
                }
            }

            if ($cleanCountry -eq 'zimbabwe') {
                return @{
                    Country = 'Zimbabwe'
                    CountryCode = 'ZW'
                    Currency = 'ZWL'
                    Capital = 'Harare'
                    InstitutionName = $displayInstitution
                    InstitutionType = $cleanType
                    BusinessName = "$displayInstitution Zimbabwe Desk"
                    Sector = 'Banking'
                    Regulator = 'Reserve Bank of Zimbabwe'
                    TaxAuthority = 'ZIMRA'
                    ProofIssuer = 'ZIMRA'
                    ProvincialLocation = 'Harare'
                    Requests = @(
                        @{ Id = "REQ-ZW-$cleanType-001"; SubjectName = "$displayInstitution Agro Traders"; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' }
                    )
                    Businesses = @(
                        @{ Id = "SB-ZW-$cleanType-001"; BusinessName = "$displayInstitution Agro Traders"; Sector = 'Agribusiness'; LoanAmount = 12000; UseOfFunds = 58; RepaymentScore = 74; RiskScore = 32; Status = 'Funded' }
                    )
                }
            }

            if ($cleanCountry -eq 'malawi') {
                return @{
                    Country = 'Malawi'
                    CountryCode = 'MW'
                    Currency = 'MWK'
                    Capital = 'Lilongwe'
                    InstitutionName = $displayInstitution
                    InstitutionType = $cleanType
                    BusinessName = "$displayInstitution Malawi Desk"
                    Sector = 'Banking'
                    Regulator = 'Reserve Bank of Malawi'
                    TaxAuthority = 'MRA'
                    ProofIssuer = 'MRA'
                    ProvincialLocation = 'Lilongwe'
                    Requests = @(
                        @{ Id = "REQ-MW-$cleanType-001"; SubjectName = "$displayInstitution Farmers Union"; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' }
                    )
                    Businesses = @(
                        @{ Id = "SB-MW-$cleanType-001"; BusinessName = "$displayInstitution Farmers Union"; Sector = 'Agriculture'; LoanAmount = 10000; UseOfFunds = 57; RepaymentScore = 75; RiskScore = 31; Status = 'Funded' }
                    )
                }
            }

            if ($cleanCountry -eq 'botswana') {
                return @{
                    Country = 'Botswana'
                    CountryCode = 'BW'
                    Currency = 'BWP'
                    Capital = 'Gaborone'
                    InstitutionName = $displayInstitution
                    InstitutionType = $cleanType
                    BusinessName = "$displayInstitution Botswana Desk"
                    Sector = 'Banking'
                    Regulator = 'Bank of Botswana'
                    TaxAuthority = 'BURS'
                    ProofIssuer = 'BURS'
                    ProvincialLocation = 'Gaborone'
                    Requests = @(
                        @{ Id = "REQ-BW-$cleanType-001"; SubjectName = "$displayInstitution Traders"; PurposeTemplate = 'Business Growth Review'; Status = 'Pending' }
                    )
                    Businesses = @(
                        @{ Id = "SB-BW-$cleanType-001"; BusinessName = "$displayInstitution Traders"; Sector = 'Retail'; LoanAmount = 14000; UseOfFunds = 56; RepaymentScore = 78; RiskScore = 29; Status = 'Funded' }
                    )
                }
            }

            if ($cleanCountry -eq 'namibia') {
                return @{
                    Country = 'Namibia'
                    CountryCode = 'NA'
                    Currency = 'NAD'
                    Capital = 'Windhoek'
                    InstitutionName = $displayInstitution
                    InstitutionType = $cleanType
                    BusinessName = "$displayInstitution Namibia Desk"
                    Sector = 'Banking'
                    Regulator = 'Bank of Namibia'
                    TaxAuthority = 'NamRA'
                    ProofIssuer = 'NamRA'
                    ProvincialLocation = 'Windhoek'
                    Requests = @(
                        @{ Id = "REQ-NA-$cleanType-001"; SubjectName = "$displayInstitution Fishing Cooperative"; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' }
                    )
                    Businesses = @(
                        @{ Id = "SB-NA-$cleanType-001"; BusinessName = "$displayInstitution Fishing Cooperative"; Sector = 'Fishing'; LoanAmount = 18000; UseOfFunds = 59; RepaymentScore = 76; RiskScore = 30; Status = 'Funded' }
                    )
                }
            }

            if ($cleanCountry -eq 'tanzania') {
                return @{
                    Country = 'Tanzania'
                    CountryCode = 'TZ'
                    Currency = 'TZS'
                    Capital = 'Dodoma'
                    InstitutionName = $displayInstitution
                    InstitutionType = $cleanType
                    BusinessName = "$displayInstitution Tanzania Desk"
                    Sector = 'Banking'
                    Regulator = 'Bank of Tanzania'
                    TaxAuthority = 'TRA'
                    ProofIssuer = 'TRA'
                    ProvincialLocation = 'Dar es Salaam'
                    Requests = @(
                        @{ Id = "REQ-TZ-$cleanType-001"; SubjectName = "$displayInstitution Tea Cooperative"; PurposeTemplate = 'Working Capital Review'; Status = 'Pending' }
                    )
                    Businesses = @(
                        @{ Id = "SB-TZ-$cleanType-001"; BusinessName = "$displayInstitution Tea Cooperative"; Sector = 'Agribusiness'; LoanAmount = 2200000; UseOfFunds = 60; RepaymentScore = 79; RiskScore = 28; Status = 'Funded' }
                    )
                }
            }

            if ($cleanCountry -eq 'uganda') {
                return @{
                    Country = 'Uganda'
                    CountryCode = 'UG'
                    Currency = 'UGX'
                    Capital = 'Kampala'
                    InstitutionName = $displayInstitution
                    InstitutionType = $cleanType
                    BusinessName = "$displayInstitution Uganda Desk"
                    Sector = 'Banking'
                    Regulator = 'Bank of Uganda'
                    TaxAuthority = 'URA'
                    ProofIssuer = 'URA'
                    ProvincialLocation = 'Kampala'
                    Requests = @(
                        @{ Id = "REQ-UG-$cleanType-001"; SubjectName = "$displayInstitution Coffee Traders"; PurposeTemplate = 'Trade Finance Review'; Status = 'Pending' }
                    )
                    Businesses = @(
                        @{ Id = "SB-UG-$cleanType-001"; BusinessName = "$displayInstitution Coffee Traders"; Sector = 'Coffee Trade'; LoanAmount = 3500000; UseOfFunds = 64; RepaymentScore = 81; RiskScore = 27; Status = 'Funded' }
                    )
                }
            }

            if ($cleanCountry -eq 'usa') {
                return @{
                    Country = 'USA'
                    CountryCode = 'US'
                    Currency = 'USD'
                    Capital = 'Washington'
                    InstitutionName = $displayInstitution
                    InstitutionType = $cleanType
                    BusinessName = "$displayInstitution USA Desk"
                    Sector = 'International'
                    Regulator = 'SEC'
                    TaxAuthority = 'IRS'
                    ProofIssuer = 'IRS'
                    ProvincialLocation = 'New York'
                    Requests = @(
                        @{ Id = "REQ-US-$cleanType-001"; SubjectName = 'Global Agro Corp'; PurposeTemplate = 'Global Expansion Review'; Status = 'Pending' }
                    )
                    Businesses = @(
                        @{ Id = "SB-US-$cleanType-001"; BusinessName = 'Global Agro Corp'; Sector = 'Multinational'; LoanAmount = 500000; UseOfFunds = 66; RepaymentScore = 82; RiskScore = 24; Status = 'Funded' }
                    )
                }
            }

            return @{
                Country = $cleanCountry
                CountryCode = $cleanCountry.Substring(0, [Math]::Min(2, $cleanCountry.Length)).ToUpperInvariant()
                Currency = 'USD'
                Capital = $cleanCountry
                InstitutionName = $displayInstitution
                InstitutionType = $cleanType
                BusinessName = "$displayInstitution Desk"
                Sector = 'General'
                Regulator = 'Local Regulator'
                TaxAuthority = 'Tax Authority'
                ProofIssuer = 'Local Regulator'
                ProvincialLocation = $cleanCountry
                Requests = @(
                    @{ Id = "REQ-$cleanCountry-$cleanType-001"; SubjectName = "$displayInstitution Business"; PurposeTemplate = 'General Assessment'; Status = 'Pending' }
                )
                Businesses = @(
                    @{ Id = "SB-$cleanCountry-$cleanType-001"; BusinessName = "$displayInstitution Business"; Sector = 'General Commerce'; LoanAmount = 25000; UseOfFunds = 55; RepaymentScore = 76; RiskScore = 35; Status = 'Funded' }
                )
            }
        }
    }
}

function New-SamplePayload {
    param([Parameter(Mandatory)] $Context)

    $today = (Get-Date).ToString('o')
    $countryName = $Context.Country
    $institutionName = $Context.InstitutionName
    $institutionType = $Context.InstitutionType

    return @{
        'authcomponent.json' = @{
            institutionName = $institutionName
            institutionType = $institutionType
            country = $Context.Country.ToLowerInvariant()
            loginMode = 'mock'
            lastLoginAt = $today
        }
        'users.json' = @{
            users = @(
                @{
                    id = "USR-$($Context.CountryCode)-001"
                    username = ($institutionName -replace '\s+', '').ToLowerInvariant()
                    displayName = "$institutionName Admin"
                    email = "admin@$($Context.CountryCode.ToLowerInvariant()).sample"
                    role = 'Administrator'
                    status = 'Active'
                },
                @{
                    id = "USR-$($Context.CountryCode)-002"
                    username = ($Context.BusinessName -replace '\s+', '').ToLowerInvariant()
                    displayName = "$institutionName Officer"
                    email = "officer@$($Context.CountryCode.ToLowerInvariant()).sample"
                    role = 'Officer'
                    status = 'Active'
                }
            )
        }
        'role-permission.json' = @{
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
        'dashboard.json' = @{
            totalConsents = 18
            activeConsents = 11
            pendingRequests = $Context.Requests.Count
            approvedRequests = [Math]::Max(1, [int]($Context.Requests | Where-Object { $_.Status -eq 'Granted' }).Count)
            rejectedRequests = [int]($Context.Requests | Where-Object { $_.Status -eq 'Denied' }).Count
            lastUpdated = $today
            country = $countryName
            institution = $institutionName
        }
        'institutional_data.json' = @{
            Requests = $Context.Requests
            Opportunities = @(
                @{ Id = "OPP-$($Context.CountryCode)-001"; BusinessName = $Context.BusinessName; DisciplineScore = 84; VerifiedRevenue = 185000; TaxComplianceStatus = 'Compliant'; TaskCompletionRate = 91; LastMonthGrowth = 12; ActiveContractCount = 3; TotalAssetValue = 420000 }
            )
            VerificationHistory = @(
                @{ Id = "PROOF-$($Context.CountryCode)-001"; SubjectName = $Context.BusinessName; DocumentType = 'Tax Clearance'; Verified = $true; VerifiedBy = $Context.ProofIssuer; VerifiedAt = (Get-Date).AddDays(-3).ToString('o') }
            )
        }
        'small_businesses.json' = @{
            Businesses = $Context.Businesses
        }
        'financial_statements.json' = @{
            balanceSheet = @{ totalAssets = 2850000; totalLiabilities = 1200000; equity = 1650000; currentRatio = 2.3 }
            incomeStatement = @{ revenue = 1850000; expenses = 1250000; netProfit = 600000; profitMargin = 32.4 }
            cashFlowStatement = @{ operatingCashFlow = 450000; investingCashFlow = -200000; financingCashFlow = -150000; netCashFlow = 100000 }
            loans = @(
                @{ lender = $Context.InstitutionName; loanAmount = 500000; outstandingBalance = 250000; interestRate = 12.5; nextPaymentDate = (Get-Date).AddDays(15).ToString('o') }
            )
        }
        'collateral.json' = @{
            collateralAssets = @(
                @{ id = "COL-$($Context.CountryCode)-001"; assetType = 'Vehicle'; assetDescription = "$institutionName delivery vehicle"; currentMarketValue = 200000; isEncumbered = $false; isInsured = $true }
            )
            propertyAndLandData = @(
                @{ id = "PROP-$($Context.CountryCode)-001"; propertyType = 'Commercial'; titleDeedNumber = "$($Context.CountryCode)/5678/2015"; propertyValue = 180000; isEncumbered = $false }
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
                @{ plotId = "P-$($Context.CountryCode)-001"; cropType = 'Maize'; variety = 'Hybrid'; areaHectares = 12.5; plantingDate = (Get-Date).AddDays(-60).ToString('o'); expectedYield = 8.2 }
            )
            harvestHistory = @(
                @{ plotId = "P-$($Context.CountryCode)-001"; harvestDate = (Get-Date).AddDays(-90).ToString('o'); yieldTonsPerHectare = 7.8; totalYield = 97.5; qualityGrade = 'Grade 1' }
            )
        }
        'investor_marketplace.json' = @{
            projects = @(
                @{ id = 1; title = "$institutionName Growth Project"; sector = $Context.Sector; requiredInvestment = 35000; isVerified = $true; location = $Context.ProvincialLocation; createdDate = (Get-Date).AddMonths(-3).ToString('o') }
            )
            investmentRanges = @(
                @{ label = 'Under 50k'; value = '0-50000'; minValue = 0; maxValue = 50000 },
                @{ label = '50k to 250k'; value = '50000-250000'; minValue = 50000; maxValue = 250000 }
            )
        }
        'projects.json' = @{
            projects = @(
                @{ id = 1; title = "$institutionName Strategic Project"; sector = $Context.Sector; requiredInvestment = 50000; isVerified = $true; location = $Context.ProvincialLocation; createdDate = (Get-Date).AddDays(-12).ToString('o') }
            )
        }
        'loans.json' = @{
            loans = @(
                @{ loanId = "LN-$($Context.CountryCode)-001"; borrower = $Context.BusinessName; amount = 50000; balance = 32000; interestRate = 12.5; nextPaymentDate = (Get-Date).AddDays(14).ToString('o') }
            )
        }
        'consent_history.json' = @{
            items = @(
                @{ consentId = "CON-$($Context.CountryCode)-001"; customerId = "CUST-$($Context.CountryCode)-001"; action = 'Granted'; timestamp = (Get-Date).AddDays(-20).ToString('o') }
            )
        }
        'active_consents.json' = @{
            items = @(
                @{ consentId = "CON-$($Context.CountryCode)-002"; customerId = "CUST-$($Context.CountryCode)-002"; status = 'Active'; expires = (Get-Date).AddDays(60).ToString('o') }
            )
        }
        'monitoring_history.json' = @{
            items = @(
                @{ businessId = "SB-$($Context.CountryCode)-001"; month = '2026-03'; utilization = 62; repayment = 81; riskScore = 29 }
            )
        }
        'energy_projects.json' = @{
            projects = @(
                @{ id = "EN-$($Context.CountryCode)-001"; title = 'Solar Irrigation Expansion'; location = $Context.ProvincialLocation; requiredInvestment = 120000; verified = $true }
            )
        }
        'climate_finance.json' = @{
            projects = @(
                @{ id = "CF-$($Context.CountryCode)-001"; title = 'Climate Smart Agriculture Program'; location = $Context.ProvincialLocation; requiredInvestment = 85000; verified = $true }
            )
        }
        'carbon_projects.json' = @{
            projects = @(
                @{ id = "CARB-$($Context.CountryCode)-001"; title = 'Agroforestry Carbon Sequestration'; location = $Context.ProvincialLocation; requiredInvestment = 90000; verified = $true }
            )
        }
        'infrastructure_projects.json' = @{
            projects = @(
                @{ id = "INF-$($Context.CountryCode)-001"; title = 'Cold Storage Network'; location = $Context.ProvincialLocation; requiredInvestment = 250000; verified = $true }
            )
        }
    }
}

function Write-JsonIfNeeded {
    param(
        [Parameter(Mandatory)] [string]$Path,
        [Parameter(Mandatory)] [object]$Value
    )

    if ((Test-Path $Path) -and -not $Force) { return }
    $Value | ConvertTo-Json -Depth 12 | Set-Content -Path $Path
}

foreach ($countryProp in $structure.PSObject.Properties) {
    $countryPath = Join-Path $Root $countryProp.Name
    if (-not (Test-Path $countryPath)) { New-Item -ItemType Directory -Path $countryPath | Out-Null }

    foreach ($typeProp in $countryProp.Value.PSObject.Properties) {
        $typePath = Join-Path $countryPath $typeProp.Name
        if (-not (Test-Path $typePath)) { New-Item -ItemType Directory -Path $typePath | Out-Null }

        foreach ($institution in $typeProp.Value) {
            $institutionPath = Join-Path $typePath $institution
            if (-not (Test-Path $institutionPath)) { New-Item -ItemType Directory -Path $institutionPath | Out-Null }

            $context = Get-Context -Country $countryProp.Name -InstitutionType $typeProp.Name -Institution $institution
            $payload = New-SamplePayload -Context $context

            foreach ($fileName in $payload.Keys) {
                Write-JsonIfNeeded -Path (Join-Path $institutionPath $fileName) -Value $payload[$fileName]
            }
        }
    }
}

Write-Host 'Sample data folders and country-specific files created successfully.'
