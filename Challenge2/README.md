# Challenge 2: Token Vendor

## Mô tả
ERC20 token (YourToken) và Vendor contract để mua/bán token tự động.

## Contract Addresses
- YourToken: `0x...` 
- Vendor: `0x...` ([View on Etherscan](https://sepolia.etherscan.io/address/0x...))

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
- Frontend: https://challenge2-lo69prr65-hungs-projects-27a31b49.vercel.app/
- Vendor Contract: https://sepolia.etherscan.io/address/0x73d7A7e957DCbc1C29363589fC05934A3044F1Ca
```