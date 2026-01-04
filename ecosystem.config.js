module.exports = {
    apps: [{
        name: "nextjs-mcqs",
        script: "./node_modules/next/dist/bin/next",
        args: "start",
        cwd: "/home/mcqs-jcq-front/htdocs/mcqs-jcq.cloud/frontend",
        interpreter: "/home/mcqs-jcq-front/.nvm/versions/node/v22.21.1/bin/node",
        env: {
            NODE_ENV: "production",
            PORT: 3003,
            PATH: "/home/mcqs-jcq-front/.nvm/versions/node/v22.21.1/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
        }
    }]
}
