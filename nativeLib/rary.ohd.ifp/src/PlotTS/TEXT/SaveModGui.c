/*
** Generated by X-Designer
*/
/*
**LIBS: -lXm -lXt -lX11
*/

#include <stdio.h>
#include <stdlib.h>
#include <X11/Xatom.h>
#include <X11/Intrinsic.h>
#include <X11/Shell.h>

#include <Xm/Xm.h>
#include <Xm/RepType.h>
#include <Xm/BulletinB.h>
#include <Xm/DialogS.h>
#include <Xm/DrawingA.h>
#include <Xm/Label.h>
#include <Xm/List.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/ScrollBar.h>
#include <Xm/ScrolledW.h>
#include <Xm/CascadeBG.h>
#include <Xm/LabelG.h>
#include "SaveTSMod.h"
#include "blank_pixmap.h"
#include "check_pixmap.h"
#include "Mods_flags.h"


void DoneBtnClicked (Widget , ModKeywords [], XtPointer *) ;
void OpTypeListClicked (Widget , int , XtPointer *) ;
void OpNameListClicked (Widget , int , XtPointer *) ;
void BeforeBtnClicked (Widget , int , XtPointer *) ;
void LastBtnClicked (Widget , int , XtPointer *) ;
int  AllItemsSelected(Widget, XmString);
/*
void XDmanage_link ( Widget w, XtPointer client_data, XtPointer call_data )
{
	if ( client_data && *(Widget *)client_data )
		XtManageChild ( *(Widget *)client_data );
}

void XDunmanage_link ( Widget w, XtPointer client_data, XtPointer call_data )
{
	if ( client_data && *(Widget *)client_data )
		XtUnmanageChild ( *(Widget *)client_data );
}

void XDpopup_link ( Widget w, XtPointer client_data, XtPointer call_data )
{
	if ( client_data && *(Widget *)client_data )
		XtPopup ( *(Widget *)client_data, XtGrabNone );
}

void XDpopdown_link ( Widget w, XtPointer client_data, XtPointer call_data )
{
	if ( client_data && *(Widget *)client_data )
		XtPopdown ( *(Widget *)client_data );
}

void XDmap_link ( Widget w, XtPointer client_data, XtPointer call_data )
{
	if ( client_data && *(Widget *)client_data )
		XtMapWidget (*(Widget *)client_data);
}

void XDunmap_link ( Widget w, XtPointer client_data, XtPointer call_data )
{
	if ( client_data && *(Widget *)client_data )
		XtUnmapWidget (*(Widget *)client_data);
}

void XDenable_link ( Widget w, XtPointer client_data, XtPointer call_data )
{
	if ( client_data && *(Widget *)client_data )
		XtSetSensitive (*(Widget *)client_data, TRUE);
}

void XDdisable_link ( Widget w, XtPointer client_data, XtPointer call_data )
{
	if ( client_data && *(Widget *)client_data )
		XtSetSensitive (*(Widget *)client_data, FALSE);
}
*/
Widget Top_level = (Widget) NULL;
Widget TitleLbl = (Widget) NULL;
Widget KeywordLbl = (Widget) NULL;
Widget OpLbl = (Widget) NULL;
Widget TypeLbl = (Widget) NULL;
Widget NameLbl = (Widget) NULL;
Widget DoneBtn = (Widget) NULL;
Widget HelpBtn = (Widget) NULL;

typedef struct _TSWidgetsType{
  Widget CheckLbl ;
  Widget IDLbl;
  Widget optionMenu1;
  Widget cascade1;
  Widget menu1;
  Widget BeforeBtn;
  Widget LastBtn; /*all above are for bulletin2 */

  int OKFlag; /*1=OK, some item in opXXXXList highlighted*/
  int LastBtnClickedFlag; /*1=LastBtn has clicked*/

  Widget Pane2;
  Widget bulletin3 ;
  Widget OpTypeList ; /*all below are for bulletin3 */
  Widget OpNameList ;
}TSWidgetsType ;

typedef struct _TSFinalType{
/*
     50 = max number of Types or Names for a given TS
     10 = max number of chars for Type or Name*/

  char OpTypes[50][10];
  char OpNames[50][10];
  int  Type_count;
}TSFinalType ;

TSWidgetsType *TSWidgetsList ;
TSFinalType  *TSFinalList ;

int TempNumTS;
int LastTSIndex,stay_in_choose_ts;
Pixmap  blank_pixmap;
Pixmap  check_pixmap;

void create_Top_level (ModKeywords TSMods[], char list_names[][10], int ListLength)
{
  Display     *display     = (Display *)    0 ;
  Widget children[10];      /* Children to manage */
  Arg al[64];                    /* Arg List */
  register int ac = 0;           /* Arg Count */
  XrmValue from_value, to_value; /* For resource conversion */
  Widget bulletin1 = (Widget)NULL;
  Widget scrolledWin1 = (Widget)NULL;
  Widget scrollbar1 = (Widget)NULL;
  Widget scrollbar2 = (Widget)NULL;
  Widget bulletin2 = (Widget)NULL;
  Widget label2 = (Widget)NULL;
  Widget scrollbar3 = (Widget)NULL;
  Widget scrollbar4 = (Widget)NULL;
	
  char TempStr[20],TempStr2[3] ;
  int i,j,background_color ;
  XmString Item ;

  XtSetArg(al[0], XtNgeometry, "700x500+200+200");ac++;
  Top_level = XtCreateApplicationShell("Top_level", topLevelShellWidgetClass, al, ac);
  display = XtDisplay(Top_level);

  ac = 0;
  XtSetArg(al[ac], XmNautoUnmanage, FALSE); ac++;
  bulletin1 = XmCreateBulletinBoard ( Top_level, "bulletin1", al, ac );
  ac = 0;
  XtSetArg(al[ac], XmNx, 12); ac++;
  XtSetArg(al[ac], XmNy, 180); ac++;
  XtSetArg(al[ac], XmNwidth, 400); ac++;
  XtSetArg(al[ac], XmNheight, 212); ac++;
  XtSetArg(al[ac], XmNscrollingPolicy, XmAUTOMATIC); ac++;
  scrolledWin1 = XmCreateScrolledWindow ( bulletin1, "scrolledWin1", al, ac );
  ac = 0;

  XtSetArg(al[ac], XmNhorizontalScrollBar, &scrollbar1); ac++;
  XtSetArg(al[ac], XmNverticalScrollBar, &scrollbar2); ac++;
  XtGetValues(scrolledWin1, al, ac );
  ac = 0;
  bulletin2 = XmCreateBulletinBoard ( scrolledWin1, "bulletin2", al, ac );
	
  XtVaGetValues(bulletin2,XmNbackground,&background_color,NULL);
  blank_pixmap = XCreatePixmapFromBitmapData
			(
			display,
			DefaultRootWindow(display),
			blank_pixmap_bits,
			blank_pixmap_width,
			blank_pixmap_height,
			BlackPixel(display, DefaultScreen(display)),
			background_color,
			DefaultDepth(display, DefaultScreen(display))
			);

 check_pixmap = XCreatePixmapFromBitmapData
			(
			display,
			DefaultRootWindow(display),
			check_pixmap_bits,
			check_pixmap_width,
			check_pixmap_height,
			BlackPixel(display, DefaultScreen(display)),
			background_color,
			DefaultDepth(display, DefaultScreen(display))
			);

  TSWidgetsList= (TSWidgetsType *)malloc(sizeof(TSWidgetsType) * TempNumTS) ;
  TSFinalList= (TSFinalType *)malloc(sizeof(TSFinalType) * TempNumTS) ;

  for (i=0;i<TempNumTS;i++)
  {
    strcpy(TempStr,TSMods[i].TSID) ;
    strcat(TempStr," ") ;
    strcat(TempStr,TSMods[i].TSType) ;
    strcat(TempStr," ") ;
    sprintf (TempStr2,"%d",TSMods[i].TimeInterval);
    strcat(TempStr,TempStr2) ;
    ac=0;
    XtSetArg(al[ac], XmNx, 51); ac++;
    XtSetArg(al[ac], XmNy, 17 + i * 67); ac++;
    XtSetArg(al[ac], XmNwidth, 130); ac++;
    XtSetArg(al[ac], XmNheight, 57); ac++;
    TSWidgetsList[i].IDLbl = XmCreateLabel ( bulletin2, TempStr, al, ac );
    ac = 0;
    XtSetArg(al[ac], XmNx, 199); ac++;
    XtSetArg(al[ac], XmNy, 30 + i * 67); ac++;
    XtSetArg(al[ac], XmNwidth, 112); ac++;
    XtSetArg(al[ac], XmNheight, 44); ac++;
    TSWidgetsList[i].optionMenu1 = XmCreateOptionMenu ( bulletin2, "optionMenu1", al, ac );
    ac = 0;
    TSWidgetsList[i].cascade1 = XmOptionButtonGadget ( TSWidgetsList[i].optionMenu1 );
    TSWidgetsList[i].menu1 = XmCreatePulldownMenu ( TSWidgetsList[i].optionMenu1, "menu1", al, ac );
    TSWidgetsList[i].BeforeBtn = XmCreatePushButton ( TSWidgetsList[i].menu1, "Before Operation", al, ac );
    TSWidgetsList[i].LastBtn = XmCreatePushButton (TSWidgetsList[i]. menu1, "Last", al, ac );
    XtSetArg(al[ac], XmNx, 10); ac++;
    XtSetArg(al[ac], XmNy, 17 + i * 67); ac++;
    XtSetArg(al[ac], XmNwidth, 20); ac++;
    XtSetArg(al[ac], XmNheight, 57); ac++;
    XtSetArg(al[ac], XmNlabelType, XmPIXMAP); ac++;
    XtSetArg(al[ac], XmNlabelPixmap, blank_pixmap); ac++;

    TSWidgetsList[i].CheckLbl = XmCreateLabel ( bulletin2, " ", al, ac );

    XtAddCallback(TSWidgetsList[i].BeforeBtn, XmNactivateCallback, (XtCallbackProc)BeforeBtnClicked, (XtPointer)i);
    XtAddCallback(TSWidgetsList[i].LastBtn, XmNactivateCallback, (XtCallbackProc)LastBtnClicked, (XtPointer)i);
  }/*end of for i loop*/
  
  ac = 0;
  XtSetArg(al[ac], XmNx, 144); ac++;
  XtSetArg(al[ac], XmNy, 24); ac++;
  TitleLbl = XmCreateLabel ( bulletin1, "Set time series Mods keywords", al, ac );
  ac = 0;
  XtSetArg(al[ac], XmNx, 96); ac++;
  XtSetArg(al[ac], XmNy, 156); ac++;
  label2 = XmCreateLabel ( bulletin1, "Time Series", al, ac );
  ac = 0;
  XtSetArg(al[ac], XmNx, 250); ac++;
  XtSetArg(al[ac], XmNy, 156); ac++;
  KeywordLbl = XmCreateLabel ( bulletin1, "Keyword", al, ac );
  ac = 0;
  XtSetArg(al[ac], XmNx, 510); ac++;
  XtSetArg(al[ac], XmNy, 60); ac++;
  OpLbl = XmCreateLabel ( bulletin1, "Operations", al, ac );
  ac = 0;
  XtSetArg(al[ac], XmNx, 484); ac++;
  XtSetArg(al[ac], XmNy, 84); ac++;
  TypeLbl = XmCreateLabel ( bulletin1, "Type", al, ac );
  ac = 0;
  XtSetArg(al[ac], XmNx, 570); ac++;
  XtSetArg(al[ac], XmNy, 84); ac++;
  NameLbl = XmCreateLabel ( bulletin1, "Name", al, ac );

  for (i=0;i<TempNumTS;i++)
  {
    ac = 0;
    XtSetArg(al[ac], XmNx, 450); ac++;
    XtSetArg(al[ac], XmNy, 112); ac++;
    XtSetArg(al[ac], XmNwidth, 200); ac++;
    XtSetArg(al[ac], XmNheight, 372); ac++;
    XtSetArg(al[ac], XmNscrollingPolicy, XmAUTOMATIC); ac++;
    TSWidgetsList[i].Pane2 = XmCreateScrolledWindow ( bulletin1, "Pane2", al, ac );
    ac = 0;

    XtSetArg(al[ac], XmNhorizontalScrollBar, &scrollbar3); ac++;
    XtSetArg(al[ac], XmNverticalScrollBar, &scrollbar4); ac++;
    XtGetValues(TSWidgetsList[i].Pane2, al, ac );
    ac = 0;
    TSWidgetsList[i].bulletin3 = XmCreateBulletinBoard ( TSWidgetsList[i].Pane2, "bulletin3", al, ac );
    XtSetArg(al[ac], XmNx, 13); ac++;
    XtSetArg(al[ac], XmNy, 16); ac++;
    XtSetArg(al[ac], XmNwidth, 68); ac++;
    XtSetArg(al[ac], XmNheight, 316); ac++;
    XtSetArg(al[ac], XmNlistSizePolicy, XmRESIZE_IF_POSSIBLE); ac++;
    TSWidgetsList[i].OpTypeList = XmCreateList (TSWidgetsList[i].bulletin3, "OpTypeList", al, ac );
    ac = 0;
    XtSetArg(al[ac], XmNx, 100); ac++;
    XtSetArg(al[ac], XmNy, 16); ac++;
    XtSetArg(al[ac], XmNwidth, 69); ac++;
    XtSetArg(al[ac], XmNheight, 318); ac++;
    XtSetArg(al[ac], XmNlistSizePolicy, XmRESIZE_IF_POSSIBLE); ac++;
    TSWidgetsList[i].OpNameList = XmCreateList (TSWidgetsList[i].bulletin3, "OpNameList", al, ac );
    for (j=0;j<ListLength/2;j++)
    {
      Item = XmStringCreate(list_names[j*2], XmSTRING_DEFAULT_CHARSET) ;
      XmListAddItem (TSWidgetsList[i].OpTypeList,Item,0) ;
      Item = XmStringCreate(list_names[j*2+1], XmSTRING_DEFAULT_CHARSET) ;
      XmListAddItem (TSWidgetsList[i].OpNameList,Item,0) ;
    }/*end of for j loop*/
    XtVaSetValues(TSWidgetsList[i].OpTypeList,XmNselectionPolicy,XmMULTIPLE_SELECT,
                XmNvisibleItemCount,ListLength/2,XmNitemCount,ListLength/2,NULL) ;
    XtVaSetValues(TSWidgetsList[i].OpNameList,XmNselectionPolicy,XmMULTIPLE_SELECT,
                XmNvisibleItemCount,ListLength/2,XmNitemCount,ListLength/2,NULL) ;
    XtAddCallback(TSWidgetsList[i].OpTypeList, XmNmultipleSelectionCallback, (XtCallbackProc)OpTypeListClicked, (XtPointer)i);
    XtAddCallback(TSWidgetsList[i].OpNameList, XmNmultipleSelectionCallback, (XtCallbackProc)OpNameListClicked, (XtPointer)i);
    TSWidgetsList[i].OKFlag=0;
    TSWidgetsList[i].LastBtnClickedFlag=0;
  }/*end of for i loop*/

  ac = 0;
  XtSetArg(al[ac], XmNx, 76); ac++;
  XtSetArg(al[ac], XmNy, 432); ac++;
  DoneBtn = XmCreatePushButton ( bulletin1, "Done", al, ac );
  ac = 0;
  XtSetArg(al[ac], XmNx, 200); ac++;
  XtSetArg(al[ac], XmNy, 432); ac++;
  HelpBtn = XmCreatePushButton ( bulletin1, "Help", al, ac );
  ac = 0;

  for (i=0;i<TempNumTS;i++)
  { ac = 0 ;
    children[ac++] = TSWidgetsList[i].BeforeBtn;
    children[ac++] = TSWidgetsList[i].LastBtn;
    XtManageChildren(children, ac); 
    ac = 0;
    XtSetArg(al[ac], XmNsubMenuId, TSWidgetsList[i].menu1); ac++;
    XtSetValues(TSWidgetsList[i].cascade1, al, ac );
    ac = 0;
    children[ac++] = TSWidgetsList[i].IDLbl;
    children[ac++] = TSWidgetsList[i].optionMenu1;
    children[ac++] = TSWidgetsList[i].CheckLbl;
    XtManageChildren(children, ac);
  }/*end of for i loop*/

  ac = 0;
  children[ac++] = bulletin2;
  XtManageChildren(children, ac);
  ac = 0;
  XmScrolledWindowSetAreas(scrolledWin1, scrollbar1, scrollbar2, bulletin2 );

  for (i=0;i<TempNumTS;i++)
  { ac = 0 ;
    children[ac++] = TSWidgetsList[i].OpTypeList;
    children[ac++] = TSWidgetsList[i].OpNameList;
    XtManageChildren(children, ac);
    ac = 0;
    children[ac++] = TSWidgetsList[i].bulletin3;
    XtManageChildren(children, ac);
    ac = 0;
    XmScrolledWindowSetAreas(TSWidgetsList[i].Pane2, scrollbar3, scrollbar4, TSWidgetsList[i].bulletin3 );
    children[ac++] = TSWidgetsList[i].Pane2;
  }/*end of for i loop*/

  children[ac++] = scrolledWin1;
  children[ac++] = TitleLbl;
  children[ac++] = label2;
  children[ac++] = KeywordLbl;
  children[ac++] = OpLbl;
  children[ac++] = TypeLbl;
  children[ac++] = NameLbl;
  children[ac++] = DoneBtn;
  children[ac++] = HelpBtn;
  XtManageChildren(children, ac);
  ac = 0;
  XtManageChild ( bulletin1);
} /*end of create_Top_level()*/


/* Global Declarations */

XtAppContext app_context = (XtAppContext) 0 ;

int TS_fill_tschng_keywords(ModKeywords TSMods[],int NumTS,char p_char[][4],int *t_int)
{
  
  int i,j,loct,operation_number;
  char list_names[MAX_OPERATIONS*2][10];
  XEvent event;

  for(i = 0; i < MAX_OPERATIONS*2; i++)
    memset(list_names[i], '\0', 10);

/*      fill list_names with operation types and names  */
  i = 0;
  loct = 1;
  while ((operation_number = t_int[loct-1]) != -1 && i < MAX_OPERATIONS * 2)
  {
    strcpy(list_names[i++], operation_types[operation_number-1]);
    if(operation_number == 4)                 /* operation names not defined for      */
      memset(list_names[i++], ' ', 8);        /* CLEAR-TS operations                  */
    else
      strncpy(list_names[i++], p_char[t_int[loct-1 + 2]-1 - 5], 8);

    loct = t_int[loct-1 + 1];
  }/*End of while loop*/
  
  TempNumTS=NumTS;
  create_Top_level (TSMods,list_names,i);
      
  XtAddCallback(DoneBtn, XmNactivateCallback, (XtCallbackProc)DoneBtnClicked, TSMods);

  XtRealizeWidget (Top_level);

  LastTSIndex=0;
  stay_in_choose_ts = TRUE;
  
  for (i=0;i<TempNumTS;i++)
    XtUnmapWidget(TSWidgetsList[i].Pane2);
  XtUnmapWidget(OpLbl);
  XtUnmapWidget(TypeLbl);
  XtUnmapWidget(NameLbl);
  XtSetSensitive(DoneBtn, FALSE); 
   
  while(stay_in_choose_ts)
  {
    XtNextEvent(&event);
    XtDispatchEvent(&event);
  }       /** end of event loop **/

} /*end of TS_fill_tschng_keywords() */

/************************Added procedures here****************/
void DoneBtnClicked(Widget w, ModKeywords TSMods[], XtPointer *call_data)
{
  int i,j,**PosList, PosCount ;
  XmString *TypeXmStr,*NameXmStr;
  XmStringCharSet  tag;
  char **Text;
  
   XmString *type_str,*name_str;
   char *type_text,*name_text;
   int select_count,select_count1,select_count2;
   int ii,jj,are_all_types_selected;



/*XmListGetSelectedPos(OpTypeList,PosList,&PosCount) ;
for (i=0;i<*PosCount;i++)
  printf ("select item is %s,%d\n",list_names[PosList[i]*2-2],*PosCount) ;
*/
  for (i=0;i<TempNumTS;i++)
  { 
    if (TSWidgetsList[i].LastBtnClickedFlag)
    { TSMods[i].NumOps=1 ;
      TSMods[i].OpTypes = (char **) malloc (sizeof(char *)) ;
      TSMods[i].OpNames = (char **) malloc (sizeof(char *)) ;
      TSMods[i].OpTypes[0] = (char *) malloc(10) ;
      TSMods[i].OpNames[0] = (char *) malloc(10) ;
      strcpy (TSMods[i].OpTypes[0],"LAST") ;
      strcpy (TSMods[i].OpNames[0]," ") ;
    }
    else
    {
      XtVaGetValues(TSWidgetsList[i].OpTypeList,XmNselectedItemCount,&PosCount,NULL);
      XtVaGetValues(TSWidgetsList[i].OpTypeList,XmNselectedItems,&TypeXmStr,NULL);
      XtVaGetValues(TSWidgetsList[i].OpNameList,XmNselectedItems,&NameXmStr,NULL);
    
      TSMods[i].NumOps=PosCount;
      TSMods[i].OpTypes = (char **) malloc (sizeof(char *) * PosCount) ;
      TSMods[i].OpNames = (char **) malloc (sizeof(char *) * PosCount) ;
      for (j=0;j<PosCount;j++)
      { TSMods[i].OpTypes[j] = (char *) malloc(10) ;
        TSMods[i].OpNames[j] = (char *) malloc(10) ;
        XmStringGetLtoR (TypeXmStr[j],XmSTRING_DEFAULT_CHARSET,&TSMods[i].OpTypes[j]) ;
        XmStringGetLtoR (NameXmStr[j],XmSTRING_DEFAULT_CHARSET,&TSMods[i].OpNames[j]) ;
      }/*end of for j loop*/

      /********  This code returns a struct that contains the selected items *************/
      for( ii=0, jj=0; ii<PosCount; ii++){
          XmStringGetLtoR( TypeXmStr[ii], XmFONTLIST_DEFAULT_TAG, &TSMods[i].OpTypes[ii]);
          are_all_types_selected=AllItemsSelected(TSWidgetsList[i].OpTypeList,
                                                  XmStringCreateLocalized(TSMods[i].OpTypes[ii])) ;

          /* printf(" strcmp = %i\n",strcmp(TSMods[i].OpTypes[jj-1],TSMods[i].OpTypes[ii]) ); */
           if( (jj >=1) &&(strcmp(TSMods[i].OpTypes[jj-1],TSMods[i].OpTypes[ii])==0)&&
                         ( are_all_types_selected==1)  ) continue;
           strcpy(TSMods[i].OpTypes[jj],TSMods[i].OpTypes[ii]);
             /* printf(" TYPE TEXT=%s \n",TSMods[i].OpTypes[jj]); */
             /*  if all of this type of Type are selected, then           */
             /*  set the first entry to type_text and set name text =" " */
             /*  printf(" are all items selected ? %i\n" ,                */
             /*  AllItemsSelected(TSWidgetsList[i].OpTypeList, */
             /*  XmStringCreateLocalized(TSMods[i].OpTypes[ii])) ); */

           if ( are_all_types_selected == 1){
             strcpy(TSMods[i].OpNames[jj]," ");
           }else{
            /* else save this entry as type_text and name_text */
             XmStringGetLtoR( NameXmStr[ii], XmFONTLIST_DEFAULT_TAG, &TSMods[i].OpNames[ii]);
             strcpy(TSMods[i].OpNames[jj],TSMods[i].OpNames[ii]);
           }
             /* printf(" NAME TEXT=%s\n",TSMods[i].OpNames[jj]); */
             jj++;
        } /* end loop over ii */

        TSMods[i].NumOps=jj;
        /* Now Display Output for Checking 
        for(ii=0; ii< TSMods[i].NumOps; ii++){
                  printf(" TSMods[i].NumOps=%i ii= %i TYPE TEXT=%s \n",
                   TSMods[i].NumOps,ii,TSMods[i].OpTypes[ii]);
                   printf(" NAME TEXT=%s\n",TSMods[i].OpNames[ii]);
        }
       */

    }/*end of else*/
  } /*end of for i loop*/

/*******************************************************************************************/

  XtDestroyWidget(Top_level);
  XFlush(XtDisplay(Top_level));
  free ((void *) TSWidgetsList);

  stay_in_choose_ts=FALSE ;
} /*end of DoneBtnClicked subroutine*/
/**********************/
void OpTypeListClicked(w, Index, call_data)
	Widget                    w;
	int        Index;
	XtPointer       *call_data;
{
  XmListCallbackStruct *cbs = (XmListCallbackStruct *) call_data ;
  int pos_cnt,*pos_list,j,selected_pos,i,TotalOKFlag,NumSelectedItem ;
  char *choice;

  XmString *type_str,*name_str;
  char *type_text,*name_text;
  int select_count,select_count1,select_count2;
  int are_all_types_selected;

/*  if (cbs->reason==XmCR_MULTIPLE_SELECT) 
          printf ("  OpTypeListClicked mult select item  \n") ; */

/* get the name and position of the selected Type and set the corresponding name as selected */
         XmStringGetLtoR( cbs->item, XmFONTLIST_DEFAULT_TAG, &choice);
         selected_pos= cbs->item_position;
  if (XmListPosSelected(TSWidgetsList[Index].OpTypeList,selected_pos)) {
         if(!XmListPosSelected(TSWidgetsList[Index].OpNameList,selected_pos) )
                XmListSelectPos(TSWidgetsList[Index].OpNameList,selected_pos,False) ;

/* now search list and find all the other items that are the same as the one selected */
  if (XmListGetMatchPos(w,XmStringCreateLocalized(choice),&pos_list,&pos_cnt)) { 
     /* printf(" The Name =%s at pos = %i exists in positions =%i\n",choice,selected_pos,pos_cnt);*/
      for(j=0; j<pos_cnt ; j++){
         if (pos_list[j]==selected_pos) continue;
         if (  XmListPosSelected(TSWidgetsList[Index].OpTypeList,pos_list[j])==False ){
            XmListSelectPos(TSWidgetsList[Index].OpTypeList,pos_list[j],False) ;
            XmListSelectPos(TSWidgetsList[Index].OpNameList,pos_list[j],False) ;
         }
      }
  } else{  
       printf(" No other matches found in list\n");
  }
} /* add else clause here (that is when the item was not highlighted originally) */
else {
/* turn off the corresponding name item */
        XmListSelectPos(TSWidgetsList[Index].OpNameList,selected_pos,False) ;
}

  XtVaGetValues(w,XmNselectedItemCount,&NumSelectedItem,NULL);
  if (NumSelectedItem==0)
  {  TSWidgetsList[Index].OKFlag=0 ;
     XtVaSetValues(TSWidgetsList[Index].CheckLbl,XmNlabelPixmap, blank_pixmap,NULL);
  }
  else
  {  TSWidgetsList[Index].OKFlag=1 ;
     XtVaSetValues(TSWidgetsList[Index].CheckLbl,XmNlabelPixmap, check_pixmap,NULL);
  }

  TotalOKFlag=0;
  for (i=0;i<TempNumTS;i++)
     TotalOKFlag+= TSWidgetsList[i].OKFlag ;
    
  if (TotalOKFlag==TempNumTS)
    XtSetSensitive(DoneBtn, TRUE) ;
  else
    XtSetSensitive(DoneBtn, FALSE);
} /*end of OpTypeListClicked subroutine*/
/**********************/
void OpNameListClicked(w, Index, call_data)
	Widget                    w;
	int        Index;
	XtPointer       *call_data;
{
  XmListCallbackStruct *cbs = (XmListCallbackStruct *) call_data ;
  int **PosList, PosCount,i,TotalOKFlag,NumSelectedItem;
  char *choice;

  if (cbs->reason==XmCR_MULTIPLE_SELECT) 
          printf ("  OpNameListClicked mult select item  \n") ; 

XmStringGetLtoR( cbs->item, XmFONTLIST_DEFAULT_TAG, &choice);
/*printf ("slection item : %s  pos= %i\n", choice, cbs->item_position) ;*/
/* set item in type list as selected (its should be at the same position) */
XmListSelectPos(TSWidgetsList[Index].OpTypeList,cbs->item_position,False) ;


  XtVaGetValues(w,XmNselectedItemCount,&NumSelectedItem,NULL);
  if (NumSelectedItem==0)
  {  TSWidgetsList[Index].OKFlag=0 ;
     XtVaSetValues(TSWidgetsList[Index].CheckLbl,XmNlabelPixmap, blank_pixmap,NULL);
  }
  else
  {  TSWidgetsList[Index].OKFlag=1 ;
     XtVaSetValues(TSWidgetsList[Index].CheckLbl,XmNlabelPixmap, check_pixmap,NULL);
  }

  TotalOKFlag=0;
  for (i=0;i<TempNumTS;i++)
     TotalOKFlag+= TSWidgetsList[i].OKFlag ;
    
  if (TotalOKFlag==TempNumTS)
    XtSetSensitive(DoneBtn, TRUE) ;
  else
    XtSetSensitive(DoneBtn, FALSE);
} /*end of OpNameListClicked subroutine*/
/**********************/
void BeforeBtnClicked(w, Index, call_data)
	Widget                    w;
	int        Index;
	XtPointer       *call_data;
{
  int i,TotalOKFlag,NumSelectedItem;
  Pixel BdColor ;
  
  XtMapWidget(OpLbl);
  XtMapWidget(TypeLbl);
  XtMapWidget(NameLbl);

  XtUnmapWidget(TSWidgetsList[LastTSIndex].Pane2);
  XtMapWidget(TSWidgetsList[Index].Pane2);
  TSWidgetsList[Index].LastBtnClickedFlag=0;


  XtVaGetValues(TSWidgetsList[Index].IDLbl,XmNbackground,&BdColor,NULL);
  XtVaSetValues(TSWidgetsList[LastTSIndex].IDLbl,XmNbackground,BdColor,NULL);

  BdColor = get_pixel_by_name(TSWidgetsList[Index].Pane2, "yellow");
  XtVaSetValues(TSWidgetsList[Index].IDLbl,XmNbackground,BdColor,NULL);
  

  XtVaGetValues(TSWidgetsList[Index].OpTypeList,XmNselectedItemCount,&NumSelectedItem,NULL);
  if (NumSelectedItem==0)
  {  TSWidgetsList[Index].OKFlag=0 ;
     XtVaSetValues(TSWidgetsList[Index].CheckLbl,XmNlabelPixmap, blank_pixmap,NULL);
  }
  else
  {  TSWidgetsList[Index].OKFlag=1 ;
     XtVaSetValues(TSWidgetsList[Index].CheckLbl,XmNlabelPixmap, check_pixmap,NULL);
  }
  
  TotalOKFlag=0;
  for (i=0;i<TempNumTS;i++)
     TotalOKFlag+= TSWidgetsList[i].OKFlag ;
    
  if (TotalOKFlag==TempNumTS)
    XtSetSensitive(DoneBtn, TRUE) ;
  else
    XtSetSensitive(DoneBtn, FALSE);

  LastTSIndex=Index;
} /*end of BeforeBtnClicked subroutine*/
/**********************/
void LastBtnClicked(w, Index, call_data)
	Widget                    w;
	int        Index;
	XtPointer       *call_data;
{
  int TotalFlag,i ;
  Pixel BdColor ;

  XtUnmapWidget(OpLbl);
  XtUnmapWidget(TypeLbl);
  XtUnmapWidget(NameLbl);
  XtUnmapWidget(TSWidgetsList[LastTSIndex].Pane2);
  XtUnmapWidget(TSWidgetsList[Index].Pane2);
  TSWidgetsList[Index].OKFlag=1;/*true*/
  TSWidgetsList[Index].LastBtnClickedFlag=1;

  XtVaSetValues(TSWidgetsList[Index].CheckLbl,XmNlabelPixmap, check_pixmap,NULL);
  XtVaGetValues(TSWidgetsList[Index].IDLbl,XmNbackground,&BdColor,NULL);
  XtVaSetValues(TSWidgetsList[LastTSIndex].IDLbl,XmNbackground,BdColor,NULL);

  BdColor = get_pixel_by_name(TSWidgetsList[Index].Pane2, "yellow");
  XtVaSetValues(TSWidgetsList[Index].IDLbl,XmNbackground,BdColor,NULL);
  

  TotalFlag=0;
  for (i=0;i<TempNumTS;i++)
    TotalFlag += TSWidgetsList[i].OKFlag ;
    
  if (TotalFlag==TempNumTS)
    XtSetSensitive(DoneBtn, TRUE);
    
  LastTSIndex=Index;

} /*end of LastBtnClicked subroutine*/
/**********************/
int  AllItemsSelected(w, item)
       Widget      w;
       XmString item;
{
  int *pos_list, pos_cnt,j,all_selected=1;

  XmListGetMatchPos(w,item, &pos_list,&pos_cnt);
  if (pos_cnt ==1)  return  0;

  for (j=0; j<pos_cnt; j++)
  {
    if (XmListPosSelected(w,pos_list[j]))
      all_selected=all_selected*1;
    else
      all_selected=all_selected*0;
  }

  return all_selected;

/*  ==============  Statements containing RCS keywords:  */
{static char rcs_id1[] = "$Source: /fs/hseb/ob72/rfc/ifp/src/PlotTS/RCS/SaveModGui.c,v $";
 static char rcs_id2[] = "$Id: SaveModGui.c,v 1.4 2006/05/03 13:09:42 aivo Exp $";}
/*  ===================================================  */

} /*end of AllItemsSelected subroutine*/