# Challenge 3: Dice Game Exploit

## Mô tả
Exploit DiceGame contract bằng cách predict random number trước khi roll.

## Cài đặt
\`\`\`bash
git clone <repo>
cd challenge-dice-game
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
- Frontend: https://challenge3-iqdc63ug7-hungs-projects-27a31b49.vercel.app/
- Vendor Contract: https://sepolia.etherscan.io/address/0x73d7A7e957DCbc1C29363589fC05934A3044F1Ca
```