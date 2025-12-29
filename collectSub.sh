#!/bin/bash
# Subdomain Collector — Created by IceCream
# FINAL VERSION — works with 1 or 1000 domains

set -euo pipefail

BASE="/home/prince/Documents/Pentest"  # Replace with your desired base path
CHAOS_KEY="ec628c2d-2bab-4a07-b86d-24f1f6bdb673"  # Replace with your actual Chaos API key

# Colors
G="\033[0;32m"
C="\033[0;36m"
Y="\033[1;33m"
R="\033[0;31m"
N="\033[0m"

echo -e "\n${C}══════ Subdomain Collector ══════${N}"
echo -e "${Y}          by IceCream${N}\n"

# === Get domains into array (this is the fix!) ===
mapfile -t domains < <(
    if [[ "${1:-}" == "-f" ]] && [[ -f "$2" ]]; then
        grep -vE '^(#|$)' "$2" | sed -E 's#^https?://##;s#/.*$##' | sort -u
    elif [[ $# -gt 0 ]]; then
        printf '%s\n' "$@" | sed -E 's#^https?://##;s#/.*$##' | sort -u
    else
        echo -e "${R}Usage: $0 domain1.com domain2.com ...${N}"
        echo -e "   or: $0 -f list.txt${N}"
        exit 1
    fi
)

[[ ${#domains[@]} -eq 0 ]] && { echo -e "${R}No domains to scan.${N}"; exit 1; }

total=${#domains[@]}
echo -e "${G}Collecting subdomains for $total domain(s)...${N}\n"

# === MAIN LOOP — now works for ALL domains ===
for ((i=0; i<total; i++)); do
    domain="${domains[i]}"
    n=$((i+1))

    echo -e "${C}[$n/$total]${N} $domain"

    folder="$BASE/$domain"
    mkdir -p "$folder"


    # Collect subdomains from all tools
    {
        subfinder -d "$domain" -all -recursive -silent 2>/dev/null || true
        assetfinder --subs-only "$domain" 2>/dev/null || true
        chaos -d "$domain" -key "$CHAOS_KEY" -silent 2>/dev/null || true
        curl -sk "https://crt.sh/?q=%25.$domain&output=json" 2>/dev/null | \
            jq -r '.[].name_value' 2>/dev/null | sed 's/\*\.//g' | tr ' ' '\n' || true
        echo "$domain" | alterx -silent 2>/dev/null || true

        # ☠️ HackerTarget
        curl -s "https://api.hackertarget.com/hostsearch/?q=$domain" | cut -d',' -f1 2>/dev/null || true

        # ☠️ RapidDNS
        curl -s "https://rapiddns.io/subdomain/$domain?full=1" | grep -oP '(?<=target="_blank">)[^<]+' | grep "$domain" 2>/dev/null || true

        # ☠️ Riddler.io
        curl -s "https://riddler.io/search/exportcsv?q=pld:$domain" | grep -oP "\\b([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\\.)+$domain\\b" 2>/dev/null || true

        # ☠️ AlienVault OTX
        curl -s "https://otx.alienvault.com/api/v1/indicators/domain/$domain/passive_dns" | jq -r '.passive_dns[].hostname' 2>/dev/null | sort -u || true

        # ☠️ URLScan.io
        curl -s "https://urlscan.io/api/v1/search/?q=domain:$domain" | jq -r '.results[].page.domain' 2>/dev/null | sort -u || true

    } 2>/dev/null | grep -v '^\[' | sort -u > "$folder/$domain.subdomains.txt"

    subs=$(wc -l < "$folder/$domain.subdomains.txt")
    echo -e "     ${Y}$subs subdomains found${N}\n"
done

echo -e "${G}All done! Results saved in:${N}"
echo -e "${Y}$BASE/${N}\n"
echo -e "${C}— IceCream —${N}"
