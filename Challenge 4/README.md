# Challenge 4: DEX (Automated Market Maker)

## Cài đặt
\`\`\`bash
git clone <repo>
cd challenge-token-vendor
yarn install
\`\`\`

## Chạy Local
\`\`\`bash
yarn chain
yarn deploy
yarn start
\`\`\`

## Deploy Sepolia
\`\`\`bash
yarn generate
Truy cập https://sepolia-faucet.pk910.de/#/ sau đó fauct eth về địa chỉ ví đã tạo để là fee gas 
yarn deploy --network sepolia
yarn verify --network sepolia
yarn vercel
\`\`\`

## Live Demo
- Frontend: https://challenge4-hllwg4qho-hungs-projects-27a31b49.vercel.app/
- Vendor Contract: https://sepolia.etherscan.io/address/0x9fC17D6c5b3E9e1dc5E57Bb45b3dd82F85eA71C8
```