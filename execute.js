const { spawn } = require('child_process')
app.get('/foo', function(req, res) {
    // Call your python script here.
    // I prefer using spawn from the child process module instead of the Python shell
    const scriptPath = 'public/store.js'
    const process = spawn('node', [scriptPath])
    process.stdout.on('data', (myData) => {
        // Do whatever you want with the returned data.
        // ...
        res.send("Done!")
    })
    process.stderr.on('data', (myErr) => {
        // If anything gets written to stderr, it'll be in the myErr variable
    })
})
