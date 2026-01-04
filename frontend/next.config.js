/** @type {import('next').NextConfig} */
const nextConfig = {
    reactStrictMode: true,
    async rewrites() {
        const apiUrl = process.env.NODE_ENV === 'production'
            ? 'https://back.mcqs-jcq.cloud'
            : 'http://127.0.0.1:8000';

        return [
            {
                source: '/api/:path*',
                destination: `${apiUrl}/api/:path*`,
            },
            {
                source: '/formatos/:path*',
                destination: `${apiUrl}/formatos/:path*`,
            },
        ]
    },
    typescript: {
        ignoreBuildErrors: true,
    },
    eslint: {
        ignoreDuringBuilds: true,
    },
}

module.exports = nextConfig
