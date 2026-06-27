FROM node:18-alpine
WORKDIR /app
COPY package.json ./
RUN npm install && npm install @vitejs/plugin-react
COPY . .
EXPOSE 3000
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
