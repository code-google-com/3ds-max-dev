using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Reflection;
using System.Windows.Forms;

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
                // Key to making sure that Visual Studio can debug
                // the Python script. This way you can attach to 3dsMax.exe
                // and catch exceptions that occur right at the correct location 
                // in the Python script. Otherwise debugging the thing is just 
                // too darn hard. 
                var options = new Dictionary<string, object>();
                options["Debug"] = true;
                ScriptRuntime sr = Python.CreateRuntime(options);
                sr.ExecuteFile(filename);                
                
                // NOTE: we could have also done something like
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
