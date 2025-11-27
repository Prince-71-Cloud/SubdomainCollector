<div align="center">

# Subdomain Collector

**Passive subdomain enumeration tool — fast, clean, reliable**  
Created with passion by **IceCream**
══════ Subdomain Collector ══════
by IceCream
</div>

## Features

- Passive only — no brute-force, no noise
- Multi-source: `subfinder` • `assetfinder` • `chaos` • `crt.sh` • `alterx`
- Works perfectly with **1 or 1000+ domains**
- Clean output: one file per domain → `domain.com.subdomains.txt`
- Beautiful colored output
- No dependencies hell — just standard recon tools

## Installation

```bash
git clone https://github.com/Prince-71-Cloud/SubdomainCollector.git
cd subdomain-collector
chmod +x collectSub.sh
```

## Usage
### Single or multiple domains
```
./collectSub.sh tesla.com google.com apple.com microsoft.com
```

### From a file (one domain per line)
```
./collectSub.sh -f domains.txt
```

### Output Example
```
Results saved in: /PATH_TO_SAVE/

├── tesla.com/
│   └── tesla.com.subdomains.txt        ← 2,156 subdomains
├── google.com/
│   └── google.com.subdomains.txt        ← 3,421 subdomains
└── apple.com/
    └── apple.com.subdomains.txt        ← 1,892 subdomains
```
### Requirements
**Make sure these tools are in your $PATH:**
```
subfinder, assetfinder, chaos, jq, curl, alterx
```
  
### Install with:
```
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install github.com/tomnomnom/assetfinder@latest
go install github.com/projectdiscovery/chaos-client/v2/cmd/chaos@latest
go install github.com/tomnomnom/alterx@latest
```
# Author
IceCream — Pentester • Recon Addict • Night City Netrunner

 ## — IceCream —


