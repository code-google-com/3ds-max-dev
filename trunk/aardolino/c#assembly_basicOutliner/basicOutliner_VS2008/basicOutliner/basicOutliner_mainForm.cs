using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace basicOutliner
{
    public partial class basicOutliner_mainForm : Form
    {
        //attributes
        //the colors for taken from the 3dsMax GUI
        private System.Drawing.Color c_fgColor;
        private System.Drawing.Color c_bgColor;
        private bool m_outliner_isExpanded = false;


        public basicOutliner_mainForm()
        {
            InitializeComponent();
        }


        //on form load, initialize all the components and sets the callback system
        private void basicOutliner_mainForm_Load(object sender, EventArgs e)
        {
            //maxscript callback system
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.addScript #sceneNodeAdded \"basicOutliner_class.update()\" id:#nodeAdd_clbck");
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.addScript #nodePostDelete \"basicOutliner_class.update()\" id:#nodeDel_clbck");
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.addScript #nodeRenamed \"basicOutliner_class.update()\" id:#nodeRename_clbck");
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.addScript #postNodesCloned \"basicOutliner_class.update()\" id:#nodeClone_clbck");
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.addScript #postMirrorNodes \"basicOutliner_class.update()\" id:#nodeMirror_clbck");

            //context menu
            m_basicOutliner_TV.ContextMenuStrip = m_basicOutlinerCMstrip;

            //treeview update
            m_basicOutliner_TV_update();
        }

        //exit operations
        private void basicOutliner_mainForm_FormClosed(object sender, FormClosedEventArgs e)
        {
            //delete all the callbacks
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.RemoveScripts #sceneNodeAdded id:#nodeAdd_clbck");
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.RemoveScripts #nodePostDelete id:#nodeDel_clbck");
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.RemoveScripts #nodeRenamed id:#nodeRename_clbck");
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.RemoveScripts #postNodesCloned id:#nodeClone_clbck");
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("callbacks.RemoveScripts #postMirrorNodes id:#nodeMirror_clbck");
        }

        //sets the image lists
        public void m_setImageList(ImageList imgList)
        {
            m_basicOutliner_TV.ImageList = imgList;
        }

        //sets the colors from the max gui
        public void m_setColors()
        {
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("maxBackColor = colorMan.getColor #background");
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("maxForeColor = colorMan.getColor #text");
            int n_bgR = ManagedServices.MaxscriptSDK.ExecuteIntMaxscriptQuery("(maxBackColor[1] * 255.0f) as integer");
            int n_bgG = ManagedServices.MaxscriptSDK.ExecuteIntMaxscriptQuery("(maxBackColor[2] * 255.0f) as integer");
            int n_bgB = ManagedServices.MaxscriptSDK.ExecuteIntMaxscriptQuery("(maxBackColor[3] * 255.0f) as integer");
            this.c_bgColor = System.Drawing.Color.FromArgb(n_bgR, n_bgG, n_bgB);
            int n_fgR = ManagedServices.MaxscriptSDK.ExecuteIntMaxscriptQuery("(maxForeColor[1] * 255.0f) as integer");
            int n_fgG = ManagedServices.MaxscriptSDK.ExecuteIntMaxscriptQuery("(maxForeColor[2] * 255.0f) as integer");
            int n_fgB = ManagedServices.MaxscriptSDK.ExecuteIntMaxscriptQuery("(maxForeColor[3] * 255.0f) as integer");
            this.c_fgColor = System.Drawing.Color.FromArgb(n_fgR, n_fgG, n_fgB);

            this.m_basicOutliner_TV.ForeColor = c_fgColor;
            this.m_basicOutliner_TV.BackColor = c_bgColor;
            this.m_basicOutlinerCMstrip.ForeColor = c_fgColor;
            this.m_basicOutlinerCMstrip.BackColor = c_bgColor;
            this.m_basicOutliner_SC.Panel1.ForeColor = c_fgColor;
            this.m_basicOutliner_SC.Panel1.BackColor = c_bgColor;
            this.m_basicOutliner_SC.Panel2.ForeColor = c_fgColor;
            this.m_basicOutliner_SC.Panel2.BackColor = c_bgColor;
            this.m_expandAll_btn.ForeColor = c_fgColor;
            this.m_expandAll_btn.BackColor = c_bgColor;
        }

/////////////////////////////////////////////////////////////////////
//methods for the outliner
/////////////////////////////////////////////////////////////////////

        //update the outliner treeview with the data from max scene
        public void m_basicOutliner_TV_update()
        {
            //get the object data from max and update the TV
            //update the treeview
            m_basicOutliner_TV.Nodes.Clear();
            TreeNode rootNode = m_basicOutliner_TV.Nodes.Add("scene root");
            rootNode.Tag = rootNode.Name = "root";
            rootNode.ImageIndex = 4;
            rootNode.SelectedImageIndex = 4;

            //maxscript, collect the objects in the scene that are not child of some other obj
            ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("clearSelection();rootsNodes = for o in objects where o.parent == undefined collect o");
            int count = ManagedServices.MaxscriptSDK.ExecuteIntMaxscriptQuery("rootsNodes.count");
            List<string> children = new List<string>();
            for (int i = 0; i < count; i++)
            {
                //add the children to the string array
                children.Add(ManagedServices.MaxscriptSDK.ExecuteStringMaxscriptQuery("rootsNodes[" + i.ToString() + "+1].name"));
            }
            m_addChildrenToTvNode(rootNode, children.ToArray());

            //order the treeview nodes
            m_basicOutliner_TV.Sort();

            //expand the root node
            rootNode.Expand();
        }

        //add children to the nodes in the treeview based on max scene hierarchy, recoursively
        private void m_addChildrenToTvNode(TreeNode rootNode, String[] childrenNodes)
        {
            int count = childrenNodes.Length;
            for (int i = 0; i < count; i++)
            {
                TreeNode newNode = rootNode.Nodes.Add(childrenNodes[i]);
                newNode.Tag = newNode.Name = childrenNodes[i];

                //assign icons to the treeview nodes 
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("c = getnodebyname \"" + childrenNodes[i].ToString() + "\"");
                
                //this code checks only for light objects, changing their icons in the outliner
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("if ((#(4113, 0) as string) == (c.classID as string) or " +
                                                                         "(#(4114, 0) as string) == (c.classID as string) or" +
                                                                         "(#(4116, 0) as string) == (c.classID as string) or" +
                                                                         "(#(4117, 0) as string) == (c.classID as string) or" +
                                                                         "(#(4115, 0) as string) == (c.classID as string) or" +
                                                                         "(#(2079724664, 1378764549) as string) == (c.classID as string) or" +
                                                                         "(#(112233, 554433) as string) == (c.classID as string) or" +
                                                                         "(#(112233, 554434) as string) == (c.classID as string) or" +
                                                                         "(#(1703759767, 1926054489) as string) == (c.classID as string) or" +
                                                                         "(#(842489804, 184704240) as string) == (c.classID as string) or" +
                                                                         "(#(861693276, 941707697) as string) == (c.classID as string) " +
                                                                         ") then b = true else b = false");
                bool objType = ManagedServices.MaxscriptSDK.ExecuteBooleanMaxscriptQuery("b");
                if (objType)
                {
                    newNode.ImageIndex = 5;
                    newNode.SelectedImageIndex = 5;
                }
                else
                {
                    newNode.ImageIndex = 2;
                    newNode.SelectedImageIndex = 2;
                }

                //recursion
                //get the children nodes, maxscript
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode = getnodebyname \"" + childrenNodes[i].ToString() + "\"");
                int childCount = ManagedServices.MaxscriptSDK.ExecuteIntMaxscriptQuery("curNode.children.count");
                List<string> nodesChildren = new List<string>();
                for (int j = 0; j < childCount; j++)
                {
                    //add the children to the string array
                    nodesChildren.Add(ManagedServices.MaxscriptSDK.ExecuteStringMaxscriptQuery("curNode.children[" + j.ToString() + "+1].name"));
                }

                m_addChildrenToTvNode(newNode, nodesChildren.ToArray());
            }
        }

        //selects a max node after the click in the outliner
        private void m_basicOutliner_TV_selectMaxNode(MouseEventArgs e)
        {
            TreeNode hitNode = m_basicOutliner_TV.GetNodeAt(e.X, e.Y);
            //if nothing is selected select NONE in max
            if (hitNode == null)
            {
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("max select none");
            }
            else if (hitNode.Tag.ToString() == "root")
            {
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("select $*");
            }
            else
            {
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode = getnodebyname \"" + hitNode.Tag.ToString() + "\"");
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("select curNode");
            }
        }

        //handler to the mouse down
        private void m_basicOutliner_TV_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left) m_basicOutliner_TV_selectMaxNode(e);
            if (e.Button == MouseButtons.Right) m_basicOutliner_TV_contextMenu(e);
        }

        //DRAG'N DROP
        private void m_basicOutliner_TV_ItemDrag(object sender, ItemDragEventArgs e)
        {
            DoDragDrop(e.Item, DragDropEffects.Move);
        }

        private void m_basicOutliner_TV_DragEnter(object sender, DragEventArgs e)
        {
            e.Effect = DragDropEffects.Move;
        }

        private void m_basicOutliner_TV_DragDrop(object sender, DragEventArgs e)
        {
            Point point = m_basicOutliner_TV.PointToClient(new Point(e.X, e.Y));
            TreeNode node = m_basicOutliner_TV.GetNodeAt(point);

            if (node != null)
            {
                //parenting in mascript
                TreeNode item = (TreeNode)e.Data.GetData("System.Windows.Forms.TreeNode");
                if (node.Tag.ToString() == "root")
                {
                    ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode = getnodebyname \"" + item.Tag.ToString() + "\"");
                    ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode.parent = undefined");
                }
                else
                {
                    ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode = getnodebyname \"" + item.Tag.ToString() + "\"");
                    ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("parentNode = getnodebyname \"" + node.Tag.ToString() + "\"");
                    ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode.parent = parentNode");
                }
            }

            //update
            m_basicOutliner_TV_update();
        }

        //context menu
        private void m_basicOutliner_TV_contextMenu(MouseEventArgs e)
        {
            m_basicOutliner_TV.ContextMenuStrip.Items.Clear();
            //select the node as first
            TreeNode hitNode = m_basicOutliner_TV.GetNodeAt(e.X, e.Y);
            //if nothing is selected select NONE in max
            if (hitNode == null)
            {
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("max select none");
                return;
            }
            else if (hitNode.Tag.ToString() == "root")
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("select $*");
            else
            {
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode = getnodebyname \"" + hitNode.Tag.ToString() + "\"");
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("select curNode");
            }

            //context menu items
            //title, object based
            ToolStripItem mi_header = m_basicOutliner_TV.ContextMenuStrip.Items.Add(hitNode.Tag.ToString());
            mi_header.Tag = hitNode.Tag.ToString();
            //separator
            ToolStripItem mi_separator = m_basicOutliner_TV.ContextMenuStrip.Items.Add("-");
            //menu items, operations
            ToolStripItem mi_delete = m_basicOutliner_TV.ContextMenuStrip.Items.Add("delete");//-->problem in undo chain...
            mi_delete.Tag = hitNode.Tag.ToString();

            ToolStripItem mi_hide = m_basicOutliner_TV.ContextMenuStrip.Items.Add("hide");
            mi_hide.Tag = hitNode.Tag.ToString();
            ToolStripItem mi_unhide = m_basicOutliner_TV.ContextMenuStrip.Items.Add("unhide");
            mi_unhide.Tag = hitNode.Tag.ToString();

            //more items should be inserted here...
        }

        //actions for the context menu items
        private void m_basicOutlinerCMstrip_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {
            if (e.ClickedItem.Text.ToString() == "delete")
            {
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode = getnodebyname \"" + e.ClickedItem.Tag.ToString() + "\"");
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("undo on (delete curNode)");
            }
            if (e.ClickedItem.Text.ToString() == "hide")
            {
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode = getnodebyname \"" + e.ClickedItem.Tag.ToString() + "\"");
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("hide curNode");
                m_basicOutliner_TV_update();
            }
            if (e.ClickedItem.Text.ToString() == "unhide")
            {
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("curNode = getnodebyname \"" + e.ClickedItem.Tag.ToString() + "\"");
                ManagedServices.MaxscriptSDK.ExecuteMaxscriptCommand("unhide curNode");
                m_basicOutliner_TV_update();
            }
        }

        //expand button
        private void m_expandAll_btn_Click(object sender, EventArgs e)
        {
            if (m_outliner_isExpanded == false)
            {
                m_basicOutliner_TV.ExpandAll();
                m_outliner_isExpanded = true;
            }
            else
            {
                m_basicOutliner_TV.CollapseAll();
                m_outliner_isExpanded = false;
            }
        }

    }
}
