# Challenge 1: Decentralized Staking App

## Smart Contract Addresses
- Staker.sol: `0x...` ([View on Etherscan](https://sepolia.etherscan.io/address/0x...))
- ExampleExternalContract: `0x...`

## Yêu cầu
- Node.js >= v20.18.3
- Yarn
- Metamask

## Cài đặt
\`\`\`bash
git clone <url...>
cd challenge-1-staking
yarn install
\`\`\`

## Chạy Local
\`\`\`bash
# Terminal 1: Local blockchain
yarn chain

# Terminal 2: Deploy contracts
yarn deploy

# Terminal 3: Start frontend
yarn start
\`\`\`

## Deploy lên Sepolia
\`\`\`bash
# Generate deployer address
yarn generate

# Check balance
yarn account

# Deploy
yarn deploy --network sepolia

# Verify contract
yarn verify --network sepolia
\`\`\`

## Deploy Frontend
\`\`\`bash
yarn vercel --prod
\`\`\`

## Live Demo
- Frontend: [https://chalenge1-9hjl6j9p9-hungs-projects-27a31b49.vercel.app/]
- Contract: [https://sepolia.etherscan.io/address/0xA189A6E85A1c41638ad4535dB970ae3075527410]

## Tests
\`\`\`bash
yarn test
\`\`\`
All tests passing ✅

## Screenshots
See `/screenshots` folder for evidence.