import React, { useState, useEffect } from "react";
import axios from "axios";

const App = () => {
  const [logs, setLogs] = useState([]);
  const [darkMode, setDarkMode] = useState(false);

  useEffect(() => {
    const fetchLogs = async () => {
      try {
        const response = await axios.get("http://localhost:8080/logs");
        setLogs(response.data);
      } catch (error) {
        console.error("Error fetching logs:", error);
      }
    };

    const intervalId = setInterval(fetchLogs, 5000);

    return () => clearInterval(intervalId);
  }, []);

  return (
    <div className={`flex h-screen ${darkMode ? "bg-gray-900 text-white" : "bg-white text-black"}`}>
      <aside className="w-64 bg-opacity-20 backdrop-blur-lg flex flex-col justify-between p-4">
        <button onClick={() => setDarkMode(!darkMode)} className="px-2 py-1 bg-gray-500 text-white rounded">
          Toggle Dark Mode
        </button>
        <h3 className="text-xl font-bold">Firewall Rules</h3>
        <div className="bg-opacity-20 backdrop-blur-lg p-4 rounded">
          {darkMode ? (
            <p className="text-green-500">Rule: Allow HTTP/HTTPS</p>
          ) : (
            <p className="text-red-500">Rule: Deny All</p>
          )}
        </div>
      </aside>
      <main className="flex flex-col w-full overflow-y-auto">
        <div className="bg-opacity-20 backdrop-blur-lg p-4 rounded-t">
          <h1 className="text-3xl font-bold">Live Traffic Logs</h1>
          <table className="w-full border-collapse mt-4">
            <thead>
              <tr className="bg-gray-800 text-white">
                <th className="border p-2">IP Source</th>
                <th className="border p-2">Port</th>
                <th className="border p-2">Protocol</th>
                <th className="border p-2">AI Decision</th>
              </tr>
            </thead>
            <tbody>
              {logs.map((log, index) => (
                <tr key={index} className={`${index % 2 === 0 ? "bg-gray-100" : "bg-white"} border`}>
                  <td className="border p-2">{log.ipSource}</td>
                  <td className="border p-2">{log.port}</td>
                  <td className="border p-2">{log.protocol}</td>
                  <td className={`border p-2 ${log.decision === "Allow" ? "text-green-500" : "text-red-500"}`}>
                    {log.decision}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </main>
    </div>
  );
};

export default App;

