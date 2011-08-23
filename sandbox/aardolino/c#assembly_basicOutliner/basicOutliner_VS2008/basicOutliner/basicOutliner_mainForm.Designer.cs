namespace basicOutliner
{
    partial class basicOutliner_mainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.m_basicOutliner_SC = new System.Windows.Forms.SplitContainer();
            this.m_basicOutliner_TV = new System.Windows.Forms.TreeView();
            this.m_basicOutlinerCMstrip = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.m_expandAll_btn = new System.Windows.Forms.Button();
            this.m_basicOutliner_SC.Panel1.SuspendLayout();
            this.m_basicOutliner_SC.Panel2.SuspendLayout();
            this.m_basicOutliner_SC.SuspendLayout();
            this.SuspendLayout();
            // 
            // m_basicOutliner_SC
            // 
            this.m_basicOutliner_SC.Dock = System.Windows.Forms.DockStyle.Fill;
            this.m_basicOutliner_SC.FixedPanel = System.Windows.Forms.FixedPanel.Panel1;
            this.m_basicOutliner_SC.IsSplitterFixed = true;
            this.m_basicOutliner_SC.Location = new System.Drawing.Point(0, 0);
            this.m_basicOutliner_SC.Name = "m_basicOutliner_SC";
            this.m_basicOutliner_SC.Orientation = System.Windows.Forms.Orientation.Horizontal;
            // 
            // m_basicOutliner_SC.Panel1
            // 
            this.m_basicOutliner_SC.Panel1.Controls.Add(this.m_expandAll_btn);
            // 
            // m_basicOutliner_SC.Panel2
            // 
            this.m_basicOutliner_SC.Panel2.Controls.Add(this.m_basicOutliner_TV);
            this.m_basicOutliner_SC.Size = new System.Drawing.Size(240, 442);
            this.m_basicOutliner_SC.SplitterDistance = 32;
            this.m_basicOutliner_SC.TabIndex = 0;
            // 
            // m_basicOutliner_TV
            // 
            this.m_basicOutliner_TV.AllowDrop = true;
            this.m_basicOutliner_TV.Dock = System.Windows.Forms.DockStyle.Fill;
            this.m_basicOutliner_TV.Location = new System.Drawing.Point(0, 0);
            this.m_basicOutliner_TV.Name = "m_basicOutliner_TV";
            this.m_basicOutliner_TV.Size = new System.Drawing.Size(240, 406);
            this.m_basicOutliner_TV.TabIndex = 0;
            this.m_basicOutliner_TV.DragDrop += new System.Windows.Forms.DragEventHandler(this.m_basicOutliner_TV_DragDrop);
            this.m_basicOutliner_TV.MouseDown += new System.Windows.Forms.MouseEventHandler(this.m_basicOutliner_TV_MouseDown);
            this.m_basicOutliner_TV.DragEnter += new System.Windows.Forms.DragEventHandler(this.m_basicOutliner_TV_DragEnter);
            this.m_basicOutliner_TV.ItemDrag += new System.Windows.Forms.ItemDragEventHandler(this.m_basicOutliner_TV_ItemDrag);
            // 
            // m_basicOutlinerCMstrip
            // 
            this.m_basicOutlinerCMstrip.Name = "m_basicOutlinerCMstrip";
            this.m_basicOutlinerCMstrip.Size = new System.Drawing.Size(61, 4);
            this.m_basicOutlinerCMstrip.ItemClicked += new System.Windows.Forms.ToolStripItemClickedEventHandler(this.m_basicOutlinerCMstrip_ItemClicked);
            // 
            // m_expandAll_btn
            // 
            this.m_expandAll_btn.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.m_expandAll_btn.Location = new System.Drawing.Point(12, 6);
            this.m_expandAll_btn.Name = "m_expandAll_btn";
            this.m_expandAll_btn.Size = new System.Drawing.Size(56, 23);
            this.m_expandAll_btn.TabIndex = 0;
            this.m_expandAll_btn.Text = "expand";
            this.m_expandAll_btn.UseVisualStyleBackColor = true;
            this.m_expandAll_btn.Click += new System.EventHandler(this.m_expandAll_btn_Click);
            // 
            // basicOutliner_mainForm
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(240, 442);
            this.Controls.Add(this.m_basicOutliner_SC);
            this.Name = "basicOutliner_mainForm";
            this.Text = "basicOutliner";
            this.Load += new System.EventHandler(this.basicOutliner_mainForm_Load);
            this.FormClosed += new System.Windows.Forms.FormClosedEventHandler(this.basicOutliner_mainForm_FormClosed);
            this.m_basicOutliner_SC.Panel1.ResumeLayout(false);
            this.m_basicOutliner_SC.Panel2.ResumeLayout(false);
            this.m_basicOutliner_SC.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.SplitContainer m_basicOutliner_SC;
        private System.Windows.Forms.TreeView m_basicOutliner_TV;
        private System.Windows.Forms.ContextMenuStrip m_basicOutlinerCMstrip;
        private System.Windows.Forms.Button m_expandAll_btn;
    }
}