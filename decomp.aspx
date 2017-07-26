<%@ Import Namespace="System.Reflection" %>
<%@ Import Namespace="System.IO" %>
<%@ Page Language="C#" %>

<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <title>decomp</title>    
</head>
<body>
    <form id="form1" runat="server">
        <asp:Button text="Decompile" OnClick="OnDecompile" runat="server" />
        <asp:FileUpload runat="server" ID="FileUpload" />
        <p>
        <asp:TextBox ID="display" textmode="Multiline" runat="server" Height="386px" Width="432px"/>
        </p>
    </form>
</body>
</html>
<script language="C#" runat="server">
    void OnDecompile(Object sender, EventArgs e)
    {
        display.Text = null;
        if (FileUpload.HasFile)
        {
            //String fileExtension = System.IO.Path.GetExtension(FileUpload.FileName).ToLower();
            String path = Server.MapPath("~\\");
            if (File.Exists(path + FileUpload.PostedFile.FileName))
                File.Delete(path + FileUpload.PostedFile.FileName);
            FileUpload.SaveAs(path+FileUpload.PostedFile.FileName);
            Assembly assembly = System.Reflection.Assembly.LoadFile(path+FileUpload.PostedFile.FileName);
            Module[] modules = assembly.GetModules();
            //Get all the goodies from inside each of the modules in our assembly.
            //Have textBox1's text += each module name, member name, etc.
            display.Text += "Assembly:\n";
            display.Text += assembly.GetName()+"\n";
            foreach (Module module in modules)
            {
                display.Text += "\nModule:\n";
                display.Text += module.Name+"\n";
                Type[] types = module.GetTypes();
                foreach (Type t in types)
                {
                    display.Text += "\tType:\n";
                    display.Text += "\t\t" + t + "\n";
                    MemberInfo[] members = t.GetMembers();
                    display.Text += "\tMembers:\n";
                    foreach (MemberInfo member in members)
                        display.Text += "\t\t" + member.Name + "\n";
                    MethodInfo[] methods = t.GetMethods();
                    foreach (MethodInfo method in methods)
                    {
                        display.Text += "\tMethod: \n";
                        display.Text += "\t\t" + method.Name + "\n";
                        display.Text += "\tParameters:\n";
                        ParameterInfo[] parameters = method.GetParameters();
                        foreach (ParameterInfo parameter in parameters)
                            display.Text += "\t\t" + parameter + "\n";
                    }
                }
            }
        }
    }
</script>