using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Windows.Forms;
using System.Threading.Tasks;
using System.IO;

using Autodesk.Max;

using Microsoft.Scripting.Hosting;
using IronPython.Hosting;

namespace PythonLauncher
{
    /// <summary>
    /// Opens a Python dialog. 
    /// <list type="unordered"> 
    /// <itme>http://ironpython.codeplex.com/releases/view/36280</itme>
    /// <item>http://msdn.microsoft.com/en-us/library/ee461504.aspx</item>
    /// <item>http://stackoverflow.com/questions/1681005/how-to-use-microsoft-scripting-hosting</item>
    /// <item>http://blogs.msdn.com/b/seshadripv/archive/2008/06/24/how-to-write-a-simple-dlr-host-in-c-using-hosting-api.aspx</item>
    /// </list>
    /// </summary>
    public class CuiRunPython : MaxCustomControls.CuiActionCommandAdapter
    {
        static OpenFileDialog ofd = new OpenFileDialog();        

        static CuiRunPython()
        {
            ofd.DefaultExt = "py";
            ofd.InitialDirectory = AppDomain.CurrentDomain.BaseDirectory + "Scripts\\Python";
            ofd.Filter = "Python files (*.py)|*.py|All files (*.*)|*.*";
        }

        public override string ActionText
        {
            get { return InternalActionText; }
        }

        public override string InternalActionText
        {
            get { return "Run Python script"; }
        }

        public override string Category
        {
            get { return InternalCategory; }
        }

        public override string InternalCategory
        {
            get { return ".NET Utilities"; }
        }

        public static void RunPythonFile(string filename)
        {
            try
            {
                // This environment variable can be used from scripts to iidentify 
                // that is being run from 3ds Max
                System.Environment.SetEnvironmentVariable("ADSKPRODUCT", "max");

                // This is the Key to making sure that Visual Studio can debug
                // the Python script. This way you can attach to 3dsMax.exe
                // and catch exceptions that occur right at the correct location 
                // in the Python script. 
                var options = new Dictionary<string, object>();
                options["Debug"] = true;

                // Create an instance of the Python run-time
                var runtime = Python.CreateRuntime(options);

                // Retrive the Python scripting engine 
                var engine = Python.GetEngine(runtime);

                // Get the directory of the file 
                var dir = Path.GetDirectoryName(filename);                       
                
                // Make sure that the local paths are available.
                var paths = engine.GetSearchPaths();                
                paths.Add(dir);
                engine.SetSearchPaths(paths);

                // Run the Python file
                runtime.ExecuteFile(filename);
                
                // NOTE: here is a cute IronPython trick with C# 4.0
                // dynamic script = py.UseFile("script.py");
                // dynamic result = script.SomFunc(); 
            }
            catch (Exception e)
            {
                MessageBox.Show("Error occurred: " + e.Message);
            }
        }
        
        public override void Execute(object parameter)
        {
            try
            {
                if (ofd.ShowDialog() != DialogResult.OK)
                    return;
                RunPythonFile(ofd.FileName);                
            }
            catch (Exception e)
            {
                MessageBox.Show("Uncaught exception occured: " + e.Message);
            }
        }       
    }
}
