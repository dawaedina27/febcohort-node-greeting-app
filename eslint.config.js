const js = require("@eslint/js");

module.exports = [
    {
        ignores:["eslint.config.js"]
    },
    
    js.configs.recommended,
    {
        files: ["**/*.js"],
        languageOptions: {
            ecmaVersion: 2021,
            globals: {
                require: "readonly",
                module: "readonly",
                exports: "readonly",
                process: "readonly",
                __dirname: "readonly",
                console: "readonly",
                describe: "readonly",
                test: "readonly",
                expect: "readonly",
                beforeEach: "readonly",
                afterEach: "readonly",
            },
        },
        rules: {
            "no-unused-vars": "warn",
            "semi": ["error", "always"],
            "quotes": ["error", "single"],
            "indent": ["error", 4],
            "eqeqeq": ["error", "always"],
            "no-var": "error",
            "prefer-const": "warn",
        },
    },
];