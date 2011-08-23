using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using System.Windows.Forms;
using System.Drawing;

namespace basicOutliner
{
    public class basicOutliner_class
    {
        //attributes
        public basicOutliner_mainForm m_mainForm = new basicOutliner_mainForm();
        public ImageList imgList = new ImageList();

        //methods
        //shows the main plugin form
        public void showForm()
        {
            //needed to use the 32bit depth for the images
            Application.EnableVisualStyles();
            Application.DoEvents();

            //load the images from the resources
            loadImages();

            //set the image list
            m_mainForm.m_setImageList(imgList);
            
            //set the colors
            m_mainForm.m_setColors();

            //show the main form
            m_mainForm.Show();
        }

        //expose the outliner update method
        public void update()
        {
            m_mainForm.m_basicOutliner_TV_update();
        }

        //loads all the images stored in the resources
        public void loadImages()
        {
            imgList.ColorDepth = ColorDepth.Depth32Bit;
            imgList.Images.Add(basicOutliner.Properties.Resources._00_aa_icon_drawed);
            imgList.Images.Add(basicOutliner.Properties.Resources._01_aa_icon_hidden);
            imgList.Images.Add(basicOutliner.Properties.Resources._02_aa_icon_geometry);
            imgList.Images.Add(basicOutliner.Properties.Resources._03_aa_icon_selected);
            imgList.Images.Add(basicOutliner.Properties.Resources._04_aa_icon_sceneRoot);
            imgList.Images.Add(basicOutliner.Properties.Resources._05_aa_icon_light);
            imgList.Images.Add(basicOutliner.Properties.Resources._06_aa_icon_expandAll);
            imgList.Images.Add(basicOutliner.Properties.Resources._07_aa_icon_drive);
            imgList.Images.Add(basicOutliner.Properties.Resources._08_aa_icon_folder);
        }
    }
}
