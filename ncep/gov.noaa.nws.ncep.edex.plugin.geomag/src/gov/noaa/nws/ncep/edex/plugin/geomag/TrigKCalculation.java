package gov.noaa.nws.ncep.edex.plugin.geomag;

import gov.noaa.nws.ncep.common.dataplugin.geomag.GeoMagAvg;
import gov.noaa.nws.ncep.common.dataplugin.geomag.GeoMagK1min;
import gov.noaa.nws.ncep.common.dataplugin.geomag.GeoMagK3hr;
import gov.noaa.nws.ncep.common.dataplugin.geomag.GeoMagRecord;
import gov.noaa.nws.ncep.common.dataplugin.geomag.dao.GeoMagAvgDao;
import gov.noaa.nws.ncep.common.dataplugin.geomag.dao.GeoMagDao;
import gov.noaa.nws.ncep.common.dataplugin.geomag.dao.GeoMagK1minDao;
import gov.noaa.nws.ncep.common.dataplugin.geomag.dao.GeoMagK3hrDao;
import gov.noaa.nws.ncep.edex.plugin.geomag.calculation.CalcEach1min;
import gov.noaa.nws.ncep.edex.plugin.geomag.calculation.CalcEach3hr;
import gov.noaa.nws.ncep.edex.plugin.geomag.calculation.CalcKp;
import gov.noaa.nws.ncep.edex.plugin.geomag.calculation.CalcUtil;

import java.io.FileNotFoundException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.raytheon.uf.common.dataplugin.message.DataURINotificationMessage;
import com.raytheon.uf.common.dataplugin.PluginException;
import com.raytheon.uf.common.dataplugin.persist.IPersistable;
import com.raytheon.uf.common.dataquery.db.QueryParam;
import com.raytheon.uf.common.datastorage.IDataStore;
import com.raytheon.uf.common.datastorage.StorageException;
import com.raytheon.uf.common.datastorage.records.IDataRecord;
import com.raytheon.uf.edex.database.DataAccessLayerException;
import com.raytheon.uf.edex.database.plugin.PluginFactory;
import com.raytheon.uf.edex.database.query.DatabaseQuery;

/**
 * This java class calculates magnetometer k index and related values.
 * 
 * <pre>
 * OFTWARE HISTORY
 *                   
 * date         Ticket#     Engineer    Description
 * -----------  ----------  ----------- --------------------------
 * 06/07/2013   #989        qzhou       Initial Creation, event driven
 * </pre>
 * 
 * @author qzhou
 * @version 1
 * */

public class TrigKCalculation {
	private final Log logger = LogFactory.getLog(getClass());
	private static final String GeoMag = "geomag";
	private static final float MISSING_VAL = 99999.99f;
	private static final int MISSING_INT = 99999;
	
	private static final int HOURS = 24;
	private static final int MINUTES = 60;
	private static final int AVG_DATA_RANGE = 30;
	private static final int HD_DATA_RANGE = 3;
	private static final int MAX_SOURCES = 3;
	
	private static final int ITERATIONS = 5;
	private GeoMagDao dao; //PluginDao dao;    
	private float[] defLength = new float[HOURS]; 
	
	String format = "yyyy-MM-dd'_'HH:mm:ss.s";     	    		
	SimpleDateFormat sdf = new SimpleDateFormat(format);
	
	
	public TrigKCalculation() {		

	}
	
	/*
	 * trigger
	 */
	public void trig1min(Object obj) throws StorageException { 
		
		if( !(obj instanceof DataURINotificationMessage) ){
			//logger.info("Received msg that is not a DataURINotificationMessage.");
			return;
		}
		
		DataURINotificationMessage uriMsg = (DataURINotificationMessage)obj;
		String[] dataUris = uriMsg.getDataURIs();
		
//		logger.info("******** Start meganetometer calculation trig.");
//		long t0 = Calendar.getInstance().getTimeInMillis();
//		System.out.println("*****T0 "+ t0);
		
		// get geomag uri
		List<String> geomagUri = new ArrayList<String>();
		
		for (String dataURI : dataUris ) {
			if (dataURI.contains("geomag"))				
				geomagUri.add(dataURI);
		}
		
		String[] dataURIs = geomagUri.toArray(new String[geomagUri.size()]);
		
		//sort
		Arrays.sort(dataURIs);
		
		try {
			dao = (GeoMagDao) PluginFactory.getInstance().getPluginDao(GeoMag);
		} catch (PluginException e) {
			e.printStackTrace();
		}
		
		calcSimpleHourAvg(dataURIs);
		calcK(dataURIs);
		
//		long t4 = Calendar.getInstance().getTimeInMillis();
//		System.out.println("*****T4 "+ t4);
	 }
	
	
	/*
	 * from geomag
	 */
	public List<?> retrieveUriForAvg(String dataUri, Date time) {
		String station = CalcUtil.getStationFromUri(dataUri);
		
		DatabaseQuery query = new DatabaseQuery(GeoMagRecord.class.getName());
		query.addReturnedField("component_1");
		query.addReturnedField("component_2");
		query.addReturnedField("dataTime.refTime");
		query.addReturnedField("badDataPoint");
		query.addReturnedField("sourceId");
		
		// called only when time is 59min, so include it.
		query.addQueryParam("dataTime.refTime", time, QueryParam.QueryOperand.LESSTHANEQUALS);
		Calendar cal = Calendar.getInstance();
		cal.setTime(time);
		cal.add(Calendar.HOUR_OF_DAY, -1); 
		
		query.addQueryParam("dataTime.refTime", cal.getTime(), QueryParam.QueryOperand.GREATERTHAN);
		query.addQueryParam("stationCode", station);
		 
		List<?> resultsList = null;
		
		try {
			resultsList = dao.queryByCriteria(query);	// 60			
		} catch (DataAccessLayerException e1) {
			e1.printStackTrace();
		}
		
		return resultsList;             		
	}
	
	/*
	 * from geomag_houravg
	 */
	public List<GeoMagAvg> retrieveSingleAvg(String dataUri, Date time) {
		GeoMagAvgDao avgDao = new GeoMagAvgDao();
		String station = CalcUtil.getStationFromUri(dataUri);
		
		List<GeoMagAvg> resultsList = null;				
		resultsList = avgDao.getSingleAvg(station, time);	
			
		return resultsList;             
        
	}
	
	/*
	 * from geomag_houravg
	 */
	public List<GeoMagAvg> retrieveUriBy3hr(String dataUri, Date spTime){
		GeoMagAvgDao avgDao = new GeoMagAvgDao();
		String station = CalcUtil.getStationFromUri(dataUri);
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(spTime);
		cal.add(Calendar.DAY_OF_YEAR, -AVG_DATA_RANGE); // at least one day is needed for gt, lt
		
		// since avg have min=30, cal.getTime() and spTime are not included
		List<GeoMagAvg> resultsList = null;				
		resultsList = avgDao.getAvgForStation(station, cal.getTime(), spTime);	//720			
		
		return resultsList;             		
	}
	
	/*
	 * from geomag
	 */
	public List<?> retrieveUriForK1min(String dataUri, Date time){
		String station = CalcUtil.getStationFromUri(dataUri);
		
		DatabaseQuery query = new DatabaseQuery(GeoMagRecord.class.getName());
		
		query.addReturnedField("component_1");
		query.addReturnedField("component_2");
		query.addReturnedField("dataTime.refTime");
		query.addReturnedField("badDataPoint");
		query.addReturnedField("sourceId");
		
		// Document uses epTime-1minute.  Consider 3 sources, we use current time
		query.addQueryParam("dataTime.refTime", time, QueryParam.QueryOperand.LESSTHANEQUALS);
		
		Date epTime = CalcUtil.getEPTime(time);
		Calendar cal = Calendar.getInstance();
		cal.setTime(epTime);
		cal.add(Calendar.HOUR_OF_DAY, -48); 
		
		// start time is epTime-48hour.  So use GREATERTHANEQUALS
		query.addQueryParam("dataTime.refTime", cal.getTime(), QueryParam.QueryOperand.GREATERTHANEQUALS);
		query.addQueryParam("stationCode", station);
		 
		List<?> resultsList = null;
		try {
			resultsList =  dao.queryByCriteria(query);	// 2880			
		} catch (DataAccessLayerException e1) {
			e1.printStackTrace();
		}
		
		return resultsList;             
	}
	
	/*
	 * from geomag_k1min
	 */
	public List<GeoMagK1min> retrieveSingleK1min(String dataUri, Date time) {
		GeoMagK1minDao k1minDao = new GeoMagK1minDao();
		String station = CalcUtil.getStationFromUri(dataUri);

		List<GeoMagK1min> resultsList = null;				
		resultsList = k1minDao.getSingleK1min(station, time);	
    	
		return resultsList;             
        
	}
	
	/*
	 * from geomag_k3hr
	 */
	public List<GeoMagK3hr> retrieveUriForK3hr(String dataUri, Date epTime){
		GeoMagK3hrDao k3hrDao = new GeoMagK3hrDao();
		String station = CalcUtil.getStationFromUri(dataUri);

		Calendar cal = Calendar.getInstance();
		cal.setTime(epTime);
		cal.add(Calendar.DAY_OF_YEAR, -1); 
		
		List<GeoMagK3hr> resultsList = null;				
		resultsList = k3hrDao.getRangeK3hr(station, cal.getTime(), epTime);	//1			
		
		return resultsList;             		
	}
	
	/*
	 * from geomag_k3hr
	 */
	public List<GeoMagK3hr> retrieveSingleK3hr(String dataUri, Date epTime){
		GeoMagK3hrDao k3hrDao = new GeoMagK3hrDao();
		String station = CalcUtil.getStationFromUri(dataUri);

		List<GeoMagK3hr> resultsList = null;				
		resultsList = k3hrDao.getSingleK3hr(station, epTime);			
		
		return resultsList;             		
	}
	
	/*
	 * For hdf5
	 */
	public IDataRecord[] getDataRecords(String uri){
		IDataRecord[] dataRec = null;
		IDataStore dataStore = null;
		
		GeoMagRecord record = new GeoMagRecord(uri);   		   			
	    if (record != null)
	    	dataStore = dao.getDataStore((IPersistable) record);
	    
	    try {				   
			dataRec = dataStore.retrieve(uri); //obs_time, compx...//size 7
		} catch (FileNotFoundException e1) {
			//e1.printStackTrace();
			System.out.println("This uri didn't find the records.");
		} catch (StorageException e1) {
			System.out.println("This uri didn't find place to store the records.");
			//e1.printStackTrace();
		}	
		
		return dataRec;
	}
	
	/*
	 * sort n lists
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	static void sort(List... lists) {
	    assert lists.length > 0;
	    
	    Object[][] objects = new Object[lists[0].size()][lists.length];

	    for (int i = 0; i < lists.length; i++) {
	        int j = 0;
	        for (Object object : lists[i]) {
	            objects[j++][i] = object;
	        }
	    }

	    Arrays.sort(objects, new Comparator<Object[]>() {
	        
			public int compare(Object[] o1, Object[] o2) {
	            return ((Comparable)o1[0]).compareTo(o2[0]);
	        }
	    });

	    for (int i = 0; i < lists.length; i++) {
	        lists[i].clear();
	        for (Object[] tuple : objects) {
	            lists[i].add(tuple[i]);
	        }
	    }
	}
	
	/*
	 * Input data of all source, output with higher priority source data
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<List> getBestObserv(List<?> dataList ) {
		
	    List<Float> comp1List = new ArrayList<Float>();
	    List<Float> comp2List = new ArrayList<Float>();
	    List<Integer> badPointList = new ArrayList<Integer>();
		List<Date> dateList = new ArrayList<Date>();
		List<Integer> sourceList = new ArrayList<Integer>();
		
		List<List> bestList = new ArrayList<List>();
		
		if (dataList != null ) { 
			for (int i = 0; i < dataList.size(); i++) {  
				
				Object[] row = (Object[]) dataList.get(i);
				
				comp1List.add( (Float) row[0]);
				comp2List.add( (Float) row[1]);
				dateList.add( (Date) row[2]);
				badPointList.add( (Integer) row[3]);
				sourceList.add( (Integer) row[4]);				
				
			}
		
			sort(dateList, sourceList, comp1List, comp2List, badPointList); 		
			
			int count = 0;
			int size = dateList.size();
			
			/*
			 * tempList combine all lists for the first 4 items. size=4
			 * newList holds tempLists ordered by source. size=3
			 * bestList construct newList with best source
			 * bestListFull filled time gaps
			 */ 		
			for (int i = 0; i < size; i=i+count) {
				count = 0;
				
				List tempList1 = new ArrayList();
				List tempList2 = new ArrayList();
				List tempList3 = new ArrayList();
				
				List<List> newList = new ArrayList<List>();   			
				//init 3
				newList.add(0, new ArrayList());
				newList.add(1, new ArrayList());
				newList.add(2, new ArrayList());
				
				tempList1.add( dateList.get(i));    				
				if (badPointList.get(i) != null && badPointList.get(i) != 0){   					
					tempList1.add(MISSING_VAL);
					tempList1.add(MISSING_VAL);    					
				}
				else {
					tempList1.add(comp1List.get(i));
					tempList1.add(comp2List.get(i));
				}    					
				newList.set(sourceList.get(i)%100 -1, tempList1);
				count++;
				
				if (i+1 < size && dateList.get(i).compareTo( dateList.get(i+1)) ==0) {
					
					tempList2.add(dateList.get(i+1));
					if (badPointList.get(i+1) != null && badPointList.get(i+1) != 0){   					
						tempList2.add(MISSING_VAL);
						tempList2.add(MISSING_VAL);    					
					}
					else {
						tempList2.add(comp1List.get(i+1));
						tempList2.add(comp2List.get(i+1));
					}    					
					newList.set(sourceList.get(i+1)%100 -1, tempList2);
					count++;
				}
				
				if (i+2 < size && dateList.get(i).compareTo( dateList.get(i+2)) ==0) {
					
					tempList3.add(dateList.get(i+2));
					if (badPointList.get(i+2) != null && badPointList.get(i+2) != 0){   					
						tempList3.add(MISSING_VAL);
						tempList3.add(MISSING_VAL);    					
					}
					else {
						tempList3.add(comp1List.get(i+2));
						tempList3.add(comp2List.get(i+2));
					}    					
					newList.set(sourceList.get(i+2)%100 -1, tempList3);
					count++;
				}
				
				if (newList.get(2) == null || newList.get(2).isEmpty()) //newList.get(0)= [3281750, 2013-05-06 00:00:00.0, 20829.85, -297.05]
					newList.remove(2);
				if (newList.get(1) == null || newList.get(1).isEmpty())
					newList.remove(1);
				if (newList.get(0) == null || newList.get(0).isEmpty()) 
					newList.remove(0);    				   								
				//System.out.println("***newList "+i+" "+count+" "+newList.size()+" "+newList.get(0));  				
				
				//  Now only check if comp2 (...get(2)) is MISSING_VAL.  Could check both				
				if (newList.get(0).get(2) != null && (Float) newList.get(0).get(2) != MISSING_VAL ) {
					bestList.add( newList.get(0));    					
				}
				else if (newList.size() >1 && (Float) newList.get(0).get(2) == MISSING_VAL && i+1< size) { 
					// if date i = date(i+1) && comp1 (i+1) != missing
					if ((Date) newList.get(0).get(1) == (Date) newList.get(1).get(1) && newList.get(1).get(2) != null && (Float) newList.get(1).get(2) !=  MISSING_VAL) {
						bestList.add( newList.get(1));         					
					}
					else if (newList.size() >2 && (Float) newList.get(1).get(2) ==  MISSING_VAL && i+2 < size) {
						if ((Date) newList.get(0).get(1) == (Date) newList.get(2).get(1) && (Float) newList.get(2).get(2) !=  MISSING_VAL) {
							bestList.add( newList.get(2));    	    					
						}
						else {
							bestList.add( newList.get(0));   
						}
					}
				}
			}
		}
	
		return bestList;
	}

	/*
	 * fill time tag gaps, return fullBestList
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public List<List> fillHDTimeGaps(List<List> bestList) {
		List<List> fullBestList= new ArrayList<List>();
		
		// fill missing in the beginning		
		Date date = (Date) bestList.get(0).get(0);    //bestList.get(i) eq. newList.  	
		int min0 = date.getMinutes();
				
		if ( min0 != 0 ) {
			for (int k = 0; k < min0; k++) {
				List newList2 = new ArrayList(); // eq. newList
				
				Date dateNew = (Date)date.clone();
				dateNew.setMinutes(k);

				newList2.add(dateNew);
				newList2.add(MISSING_VAL);
				newList2.add(MISSING_VAL);				
				fullBestList.add( newList2);
		
			}			
		}
		
			// fill missing in the middle
			for (int j = 0; j < bestList.size(); j++ ) { //i=0 first non missing data		
				
				Date date0 = (Date) bestList.get(j).get(0);//dateList.get(i);
				fullBestList.add( bestList.get(j));
				
				if (j+1 < bestList.size()) {	
					Date date1 = (Date) bestList.get(j+1).get(0);//dateList.get(i+1);
					int diffMin = (int)(date1.getTime() - date0.getTime())/ (60*1000);
					
					if (diffMin != 1) {
						for (int k = 0; k < diffMin-1; k++) { 
							List newList2 = new ArrayList(); // eq. newList
							
							newList2.add(new Date(date0.getTime() + 60*1000*(k+1)));
							newList2.add(MISSING_VAL);
							newList2.add(MISSING_VAL);
							fullBestList.add( newList2);
							
						}
					}
				}	
			}
		
//		// fill missing in the end
//		int latest = fullBestList.size();
//		if (latest < HOURS*MINUTES*HD_DATA_RANGE) {
//			for (int k = latest; k < HOURS*MINUTES*HD_DATA_RANGE; k++) {
//				List newList2 = new ArrayList();
//				Date d = (Date)fullBestList.get(0).get(latest-1);
//				
//				newList2.add(new Date(d.getTime() + 60*1000*(k+1)));
//				newList2.add(MISSING_VAL);
//				newList2.add(MISSING_VAL);
//				fullBestList.add( newList2);			
//			}
//		}
		
		return fullBestList;
	}
	
	
	/*
	 * when uri time is 59 min past the hour, calculate the averages and write to geomat_houravg
	 */
	public void calcSimpleHourAvg(String[] dataURIs) throws StorageException {	  
		
		if (dao != null && dataURIs != null) {
			for (String dataURI : dataURIs ) {
    			String stationCode = CalcUtil.getStationFromUri(dataURI);
    			
    			Date time = null;;
				try {
					time = CalcUtil.getTimeFromUri(dataURI);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				int min = time.getMinutes();	
			
    			List<?> dataList = null;
    			if (min == 59)
    				dataList = retrieveUriForAvg(dataURI, time);
    			else
    				continue;
    				
    			
    			if (dataList != null && dataList.size() != 0) {
    				List<List> bestList = getBestObserv( dataList );
    			    	    	
	    			float[] hrAvg = CalcEach3hr.getSimpleHourAvg(bestList);	
	    			
	    			GeoMagAvg recAvg = new GeoMagAvg();

	    			// look the avg table to see if the avg already exists
	    			time.setMinutes(30);
	    			List<GeoMagAvg> avgList = retrieveSingleAvg(dataURI, time);
	    			
	    			if (avgList != null && avgList.size() != 0) {//String newUri = dataURI.substring(0, 21) +":30:00.0"+ dataURI.substring(29, 34)+ "100/GEOMAG";
	    				for (int i = 0; i < avgList.size(); i++) {  //1 	    					
	    					GeoMagAvg row = avgList.get(i);
	    					List<Integer> idList = new ArrayList<Integer>();
	    					idList.add( (Integer) row.getId());
	    					recAvg.setId((int) idList.get(0));
	    					
	    				}
	    			}
	    			
					recAvg.setAvgTime(time);
					recAvg.setInsertTime(Calendar.getInstance().getTime());
					recAvg.setStationCode(stationCode);
					recAvg.setHHrAvg(hrAvg[0]);
					recAvg.setDHrAvg(hrAvg[1]);
					
					GeoMagAvgDao avgDao = new GeoMagAvgDao();
					avgDao.persist(recAvg);
		
    			}
        	} 
		}
		
    }

	
	/*
	 * Write to geomag_k1min
	 */
	public void calcK(String[] dataURIs) {
		
		if (dataURIs != null ) {			
    		for (String dataURI : dataURIs ) {
    			
    			String stationCode = CalcUtil.getStationFromUri(dataURI);
    			String source = CalcUtil.getSourceFromUri(dataURI);
    			
    			Date timeBy3 = null;;
				try {
					timeBy3 = CalcUtil.getTimeFromUri(dataURI);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				int hour = timeBy3.getHours();
				int min = timeBy3.getMinutes();
				
				/*
		    	 * Read average
		    	 */
				Date spTime = CalcUtil.getSPTime( timeBy3);
				
				List<GeoMagAvg> dataList = null;

    				dataList = retrieveUriBy3hr(dataURI, CalcUtil.getSPTime(timeBy3));

				// dataList size (avg) < 24, can't calculate dB[j]
				if (dataList.size() <= HOURS)
    				continue;

    			
    			List<Date> dateList = new ArrayList<Date>();
			    List<Float> hHrAvgList = new ArrayList<Float>();
			    List<Float> dHrAvgList = new ArrayList<Float>();
			      		    		
    			if (dataList != null && dataList.size() >= 5) { 
    				for (int i = 0; i < dataList.size(); i++) {  //1 extra
    					
    					GeoMagAvg row = dataList.get(i);
    					
    					dateList.add( (Date) row.getAvgTime());
    					hHrAvgList.add( (Float) row.getHHrAvg());
    					dHrAvgList.add( (Float) row.getDHrAvg());    					
	    			
	    			}
    			    	    			 
	    			sort(dateList, hHrAvgList, dHrAvgList); 
	    			
	    			/*
	    			 *  fill missing
	    			 */
	    			List<Date> dateListFinal = new ArrayList<Date>();
	    		    List<Float> hHrAvgListFinal = new ArrayList<Float>();
	    		    List<Float> dHrAvgListFinal = new ArrayList<Float>();
	    			
	    		    // fill missing in the beginning		
	    			Date date = (Date) dateList.get(0);  	
	    			int hr0 = date.getHours();
	    					
	    			if ( hr0 != spTime.getHours() ) {
	    				for (int k = 0; k < hr0; k++) {
	    					
	    					Date dateNew = (Date)date.clone();
	    					dateNew.setMinutes(k);
			
	    					dateListFinal.add( dateNew);
	    					hHrAvgListFinal.add( MISSING_VAL);
							dHrAvgListFinal.add( MISSING_VAL);								
	    				}			
	    			}
	    			
	    			// fill missing in the middle
	    			for (int i = 0; i < dateList.size(); i++) {  
	    					Date date0 = dateList.get(i);
	    					dateListFinal.add(date);
	    					hHrAvgListFinal.add( hHrAvgList.get(i));
						dHrAvgListFinal.add( dHrAvgList.get(i));
	    					
						if (i+1 < dateList.size()) {	
	    					Date date1 = (Date)dateList.get(i+1);
	    					int diffHr = (int)(date1.getTime() - date0.getTime())/ (3600*1000);

	    					if (diffHr != 1) {
	    						for (int j = 0; j < diffHr-1; j++) {  
	    							dateListFinal.add( new Date(date.getTime() + 3600*1000*(j+1))); //append after i, i+1
	    							hHrAvgListFinal.add( MISSING_VAL);
	    							dHrAvgListFinal.add( MISSING_VAL);
	    								
	    						}
	    					}
	    				}	
	    			}
				    
	    			// fill missing in the end
	    			int latest = dateListFinal.size();
	    			if (latest < HOURS*AVG_DATA_RANGE) {
	    				for (int k = latest; k < HOURS*AVG_DATA_RANGE; k++) {
	    					dateListFinal.add(new Date(dateListFinal.get(latest-1).getTime() + 3600*1000*(k+1)));
							hHrAvgListFinal.add( MISSING_VAL);
							dHrAvgListFinal.add( MISSING_VAL);
	    				}
	    			}
    			
    			
					float[] hHrAvgs = CalcUtil.toFloatArray(hHrAvgListFinal);
					float[] dHrAvgs = CalcUtil.toFloatArray(dHrAvgListFinal);
					
	    			float[] dB = CalcEach3hr.getDisturbanceLevel(hHrAvgs, dHrAvgs);
//	    			for ( int k = 0; k < 30; k++ )
//	    	        	System.out.print("*****dB "+ dB[k]+" ");
//	    			System.out.println("");
					
	    	    	@SuppressWarnings("unchecked")
	    			Map<Integer, Float> dBsmall = CalcEach3hr.getSmallDisturbanceLevel(dB);
	    	    	
	    	    	float[] quietHHrAvg = CalcEach3hr.getQuietLevelHourAvg(dBsmall, hHrAvgs);
	    	    	float[] quietDHrAvg = CalcEach3hr.getQuietLevelHourAvg(dBsmall, dHrAvgs);  

//		    	    System.out.println("***hHrAvgs "+ CalcUtil.maxValue(hHrAvgs)+ " "+CalcUtil.minValue(hHrAvgs)+" "+hHrAvgs[0]+" "+hHrAvgs[1]+" "+hHrAvgs[2]);
//		    	    	System.out.println("***dHrAvgs "+ CalcUtil.maxValue(dHrAvgs)+ " "+CalcUtil.minValue(dHrAvgs)+" "+dHrAvgs[0]+" "+dHrAvgs[10]);
//		    	    	System.out.println("***quietHHrAvg "+ CalcUtil.maxValue(quietHHrAvg)+ " "+CalcUtil.minValue(quietHHrAvg)+" "+quietHHrAvg[0]+" "+quietHHrAvg[10]);
//		    	    	System.out.println("***quietdHrAvg "+ CalcUtil.maxValue(quietDHrAvg)+ " "+CalcUtil.minValue(quietDHrAvg)+" "+quietDHrAvg[0]+" "+quietDHrAvg[10]);
	    	    	
	    	    	// added from FMIQDCRT11_3hr.pro
	    	    	for ( int k = 0; k < quietHHrAvg.length; k++ ){
	    	    		if (quietHHrAvg[k] == MISSING_VAL || quietDHrAvg[k] == MISSING_VAL) {
	    	    			quietHHrAvg[k] = CalcUtil.getMedian(quietHHrAvg);
	    	    			quietDHrAvg[k] = CalcUtil.getMedian(quietDHrAvg);
	    	    		}
	    	    	}
    	    	
	    	    	float[] qha = CalcEach3hr.getQHA(quietHHrAvg);
	    	    	float[] qda = CalcEach3hr.getQHA(quietDHrAvg);
//	    	    	System.out.println("***qha "+ CalcUtil.maxValue(qha)+ " "+CalcUtil.minValue(qha)+" "+qha[0]+" "+qha[10]);
//	    	    	System.out.println("***qda "+ CalcUtil.maxValue(qda)+ " "+CalcUtil.minValue(qda)+" "+qda[0]+" "+qda[10]);
	    	    	
	    	    	float[] hQdc = CalcEach1min.getHarmonicFit(qha);//[1440]
			    	float[] dQdc = CalcEach1min.getHarmonicFit(qda);
//				    System.out.println("***hQdc "+ CalcUtil.maxValue(hQdc)+ " "+CalcUtil.minValue(hQdc)+" "+hQdc[0]+" "+hQdc[10]);
//				    System.out.println("***dQdc "+ CalcUtil.maxValue(dQdc)+ " "+CalcUtil.minValue(dQdc)+" "+dQdc[0]+" "+dQdc[10]);
			    	
			    	float[] qhaQdc = CalcEach1min.getQHAQDC(hQdc);//[1440]
			    	float[] qdaQdc = CalcEach1min.getQHAQDC(dQdc);
//			    	System.out.println("***qhaQdc "+ CalcUtil.maxValue(qhaQdc)+ " "+CalcUtil.minValue(qhaQdc)+" "+qhaQdc[0]+" "+qhaQdc[10]+" "+station);
//			    	System.out.println("***qdaQdc "+ CalcUtil.maxValue(qdaQdc)+ " "+CalcUtil.minValue(qdaQdc)+" "+qdaQdc[0]+" "+qdaQdc[10]);
	
	
			    	/*
			    	 * Read H and D
			    	 */
		Map<String, List<float[]>> kIndexMap = new HashMap<String, List<float[]>>();
		 
	    			Date timeBy1 = null;
				try {
					timeBy1 = CalcUtil.getTimeFromUri(dataURI);
						
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

					Date epTime = CalcUtil.getEPTime( timeBy1);
				int epHour = epTime.getHours();
    			
					/*
					 * change epTime to current time
					 */
	    			List<?> hdDataList = retrieveUriForK1min(dataURI, timeBy1);
	
	    			if (hdDataList != null && hdDataList.size() != 0) {
	    				// if dataList <= 1440, can't calculate k-index
	    				if (hdDataList.size() <= HOURS*MINUTES)
	    				    continue;

	    			// gest best observation data
	    				List<List> bestList = getBestObserv( hdDataList );
	    				    if (bestList.size() <= HOURS*MINUTES)
	    				    	continue;
				
	    				List<List> bestListFull = fillHDTimeGaps( bestList);
	    				// System.out.println("**dataListBy1 size"+dataList.size()+" "+bestList.size()+" "+bestListFull.size());	    				
				
    			// get hdata, ddata
					    float[] hdata = new float[HD_DATA_RANGE*HOURS*MINUTES];
						float[] ddata = new float[HD_DATA_RANGE*HOURS*MINUTES];
					    
					    Arrays.fill(hdata, MISSING_VAL);
					    Arrays.fill(ddata, MISSING_VAL);
	    			   
						for (int i = 0; i < bestListFull.size(); i++) {	
							List<Float> list = (List<Float>) bestListFull.get(i);
						if (list != null && !list.isEmpty()) {
							hdata[i] = list.get(1);
							ddata[i] = list.get(2);					
						}			
					}
					
	//					System.out.println("***hdata "+ CalcUtil.maxValue(hdata)+ " "+CalcUtil.minValue(hdata)+" "+hdata[0]+" "+hdata[2879]);
	//			    	System.out.println("***ddata "+ CalcUtil.maxValue(ddata)+ " "+CalcUtil.minValue(ddata)+" "+ddata[0]+" "+ddata[2879]);

			    	defLength = CalcEach3hr.getDefLength(stationCode, epHour);
			    	
			    	float[] hhdata = CalcEach1min.fillGaps(hdata);
			    	float[] dddata = CalcEach1min.fillGaps(ddata);
			    	
			    	int currTimeIndex = CalcEach1min.getCurrTimeIndex(hour, min, epHour);
				    	//System.out.println("**currTimeIndex "+currTimeIndex);
			    	
			    	hhdata = CalcEach1min.getExtrapolation(hhdata, qhaQdc, currTimeIndex);
			    	dddata = CalcEach1min.getExtrapolation(dddata, qdaQdc, currTimeIndex);
	//		    	System.out.println("***hhdataExtr "+ CalcUtil.maxValue(hhdata)+ " "+CalcUtil.minValue(hhdata)+" "+hhdata[0]+" "+hhdata[10]);
	//		    	System.out.println("***dddataExtr "+ CalcUtil.maxValue(dddata)+ " "+CalcUtil.minValue(dddata)+" "+dddata[0]+" "+dddata[10]);
				    
			    	float[] hDev = CalcEach1min.getDev(hhdata, hQdc);//[1440]
			    	float[] dDev = CalcEach1min.getDev(dddata, dQdc);
	//			    	System.out.println("***hDev "+ CalcUtil.maxValue(hDev)+ " "+CalcUtil.minValue(hDev)+" "+hDev[0]+" "+hDev[10]);
	//			    	System.out.println("***dDev "+ CalcUtil.maxValue(dDev)+ " "+CalcUtil.minValue(dDev)+" "+dDev[0]+" "+dDev[10]);
			    	
			    	//already considered missing in getDev
			    	
			    	int[] kLimit = CalcUtil.getKLimit(stationCode); 
			    	
			    	int missingFlag = 0;
			    	List<float[]> kList = CalcEach1min.getKIndex(hDev, dDev, kLimit, missingFlag);//[8]
		
			    	float[] kIndex =  kList.get(0);
			    	float[] gamma =  kList.get(1);
			    	
			    	float[] kLength = CalcUtil.geKLength();//[8]
			    	float[] fitLength = CalcEach1min.getFitLength(defLength, kIndex, kLength);//[24]
			    	
			    	
			    	float[] hcA = CalcEach1min.getCentHourAvg(hhdata, fitLength, kIndex);//middle [24]
			    	float[] dcA = CalcEach1min.getCentHourAvg(dddata, fitLength, kIndex);
	//			    	System.out.println("***hcA "+ CalcUtil.maxValue(hcA)+ " "+CalcUtil.minValue(hcA)+" "+hcA[0]+" "+hcA[10]+" "+stationCode);
	//			    	System.out.println("***dcA "+ CalcUtil.maxValue(dcA)+ " "+CalcUtil.minValue(dcA)+" "+dcA[0]+" "+dcA[10]);
			    	  
			    	hcA = CalcEach1min.adjustHrCentAvg(hcA, qha, gamma, kLimit);
			    	dcA = CalcEach1min.adjustHrCentAvg(dcA, qda, gamma, kLimit);
	//			    	System.out.println("***hcAAdj "+ CalcUtil.maxValue(hcA)+ " "+CalcUtil.minValue(hcA)+" "+hcA[0]+" "+hcA[10]);
	//			    	System.out.println("***dcAAdj "+ CalcUtil.maxValue(dcA)+ " "+CalcUtil.minValue(dcA)+" "+dcA[0]+" "+dcA[10]);
			    	
			    	// Harmonic Fit to derive the qdc
				    	int foundMiss = 0;
				    	for (int i=0; i<hcA.length; i++) {
			    		if (hcA[i] == MISSING_VAL) {
				    			foundMiss = 1;
			    			hQdc = hQdc;
			    			break; 
			    		}
				    	}
				    	if (foundMiss == 0) 
			    			hQdc = CalcEach1min.getHarmonicFit(hcA);
	
				    	foundMiss = 0;
				    	for (int i=0; i<dcA.length; i++) {
				    		if (dcA[i] == MISSING_VAL) {
				    			foundMiss = 1;
			    			dQdc = dQdc;
			    			break; 
			    		}
				    	}
				    	if (foundMiss == 0) 
			    			dQdc = CalcEach1min.getHarmonicFit(dcA);
			    	
	//		    	System.out.println("***hQdc2 "+ CalcUtil.maxValue(hQdc)+ " "+CalcUtil.minValue(hQdc)+" "+hQdc[0]+" "+hQdc[10]);
	//		    	System.out.println("***dQdc2 "+ CalcUtil.maxValue(dQdc)+ " "+CalcUtil.minValue(dQdc)+" "+dQdc[0]+" "+dQdc[10]);
			    	
				    	/*
				    	 * Do a few iterations. check for convergence of k_index and exit loop 
				    	 * Done before ITERATIONS if you see two passes with identical values for k_index
				    	 */			    
			    	float[] last_kindex = new float[8];
			    	Arrays.fill(last_kindex, -1);
			    	
			    	/* Check for convergence of k_index and exit loop 
			    	 * before ITERATIONS are done if you see two passes with
			    	 * identical values for k_index
			    	 */
			    	for (int num = 0; num < ITERATIONS; num++) {
			    		float kchange = 0;
			    		hDev = CalcEach1min.getDev(hhdata, hQdc);
			        	dDev = CalcEach1min.getDev(dddata, dQdc);
			        		
			        	kList = CalcEach1min.getKIndex(hDev, dDev, kLimit, missingFlag);
			        	kIndex =  kList.get(0);
			        	gamma =  kList.get(1);
			        	 
			        	// Check for convergence of k_index
			        	if (kIndex.length == 8 && last_kindex.length == 8)
				        	for (int i=0; i<last_kindex.length; i++){
				        		kchange += Math.abs(kIndex[i] - last_kindex[i]);
				        		//System.out.println("**kchange "+ kIndex[i] +" " +last_kindex[i]+" "+(kIndex[i] -last_kindex[i]));
				        	}
			        	if (kchange == 0) 
				        	break;
	
			        	fitLength = CalcEach1min.getFitLength(defLength, kIndex, kLength);
			        	
			        	hcA = CalcEach1min.getCentHourAvg(hhdata, fitLength, kIndex);
			        	dcA = CalcEach1min.getCentHourAvg(dddata, fitLength, kIndex);
			        	
			        	hcA = CalcEach1min.adjustHrCentAvg(hcA, qha, gamma, kLimit);
			        	dcA = CalcEach1min.adjustHrCentAvg(dcA, qda, gamma, kLimit);
			        	
			        	// Harmonic Fit to derive the qdc
				        	foundMiss = 0;
					    	for (int i=0; i<hcA.length; i++) {
				    		if (hcA[i] == MISSING_VAL) {
					    			foundMiss = 1;
				    			hQdc = hQdc;
				    			break; 
				    		}
					    	}
					    	if (foundMiss == 0) 
				    			hQdc = CalcEach1min.getHarmonicFit(hcA);
	
					    	foundMiss = 0;
					    	for (int i=0; i<dcA.length; i++) {
					    		if (dcA[i] == MISSING_VAL) {
					    			foundMiss = 1;
				    			dQdc = dQdc;
				    			break; 
				    		}
					    	}
					    	if (foundMiss == 0) 
				    			dQdc = CalcEach1min.getHarmonicFit(dcA);
				    	
				    	last_kindex = kIndex.clone();
			    	}
			    	
			    	// Now do the calculation using the original data (hdata, ddata)
			    	hDev = CalcEach1min.getDev(hdata, hQdc);//[1440]
			    	dDev = CalcEach1min.getDev(ddata, dQdc);
		        	
			    	kList = CalcEach1min.getKIndex(hDev, dDev, kLimit, missingFlag);		    	
			    	kIndex =  kList.get(0);
			    	gamma =  kList.get(1);
				    	
			    	float[] hkIndex =  kList.get(2);
			    	float[] hGamma =  kList.get(3);
			    	float[] dkIndex =  kList.get(4);
			    	float[] dGamma =  kList.get(5);
			    	int lastHCount = 0;
			    	int lastDCount = 0;
			    	
			    	for (int i = 2700; i < 2880; i++) {
			    		if (hdata[i] != MISSING_VAL)
			    			lastHCount++;
			    		if (hdata[i] != MISSING_VAL)
			    			lastDCount++;
			    	}
			    	
			    	float[] count = new float[2];
			    	count[0] = lastHCount;
			    	count[1] = lastDCount;
			    	kList.add(6, count);
				    	kIndexMap.put(stationCode+source, kList);
				    	
			    	
			    	float[] kest = CalcKp.getKest(stationCode, kList.get(0), kList.get(1));
			    	
			    	float ks = 0;
			    	try {
							ks = CalcKp.getKs(stationCode, (int) kIndex[7], (Date) timeBy1.clone()); // 7 is last point kIndex					
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
	
			    	int a_est = CalcKp.getAest(stationCode, (int) kIndex[7]);
			    	
					
					// 1 min
					int kest_index =   (int) kIndex[7];
					float kest_real =  CalcKp.getKest(stationCode, (int) kIndex[7], gamma[7]);					
					float kest_gamma = gamma[7];					
					float hk_real =    CalcKp.getKest(stationCode, (int) hkIndex[7], hGamma[7]);
					float hgamma =     hGamma[7];
					float dk_real =    CalcKp.getKest(stationCode, (int) dkIndex[7], dGamma[7]);
					float dgamma =     dGamma[7];	
					int hkindex =      (int) hkIndex[7];
					int dkindex =      (int) dkIndex[7];
						int countH = (int) count[0];
						int countD = (int) count[1];
					float ksArray = ks;	
					int aestArray = a_est;
		    		
					
	    			GeoMagK1min recK1min = new GeoMagK1min();   			
		    			
		    			List<GeoMagK1min> k1minList = retrieveSingleK1min(dataURI, timeBy1);
		    			
		    			if (k1minList != null && k1minList.size() != 0) {//String newUri = dataURI.substring(0, 21) +":30:00.0"+ dataURI.substring(29, 34)+ "100/GEOMAG";
		    				for (int i = 0; i < k1minList.size(); i++) {  //1 	    					
		    					GeoMagK1min row = k1minList.get(i);
		    					
		    					int id = (Integer) row.getId();
		    					if (id != 0)
		    						recK1min.setId(id);	    					
		    				}
		    			}
						
	    			recK1min.setRefTime(timeBy1);
	    			recK1min.setLastUpdate(Calendar.getInstance().getTime());
	    			recK1min.setStationCode(stationCode);
	    			recK1min.setKestIndex(kest_index);
	    			recK1min.setKestReal(kest_real);
	    			recK1min.setKestGamma(kest_gamma);
	    			recK1min.setHKIndex(hkindex);
	    			recK1min.setHKReal(hk_real);
	    			recK1min.setHKGamma(hgamma);
	    			recK1min.setDKIndex(dkindex);
	    			recK1min.setDKReal(dk_real);
	    			recK1min.setDKGamma(dgamma);
	    			recK1min.setKs(ksArray);
	    			recK1min.setAest(aestArray);
		    			recK1min.setHCount(countH);
		    			recK1min.setDCount(countD);
	    			    			
					GeoMagK1minDao k1minDao = new GeoMagK1minDao();
					k1minDao.persist(recK1min);
		
		    	    	calcK3h(dataURI, kest_index, kest_real, kest_gamma);
    	    	
				} // end of for dataURI
		    }
	    }
		}	  	
	}
		
	/*
	 * write to geomag_k3hr
	 */
	public void calcK3h(String dataURI, int kest_index, float kest_real, float kest_gamma){
		List<Integer> idDb = new ArrayList<Integer>();	
		List<Date> dateDb = new ArrayList<Date>();	
		List<Integer> kIndexDb = new ArrayList<Integer>();	
		List<Float> kGammaDb = new ArrayList<Float>();	
		List<Integer> kestIndexDb = new ArrayList<Integer>();	
		
		int aRun = 0;
		
    			String stationCode = CalcUtil.getStationFromUri(dataURI);
    			
		Date currTime = null;
				try {
			currTime = CalcUtil.getTimeFromUri(dataURI);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
		int hour = currTime.getHours();
		int min = currTime.getMinutes();
		Date epTime = CalcUtil.getEPTime(currTime);
				
		GeoMagK3hr recK3hr = new GeoMagK3hr();


		List<GeoMagK3hr> k3hrList = retrieveUriForK3hr(dataURI, epTime); //epTime not in the list
    			
		if (k3hrList != null && k3hrList.size() != 0) { 
			      		    		
	    	for (int i = 0; i < k3hrList.size(); i++) {
				
				GeoMagK3hr row = (GeoMagK3hr) k3hrList.get(i);
    					
				dateDb.add (row.getRefTime());
				idDb.add ( row.getId());
				kIndexDb.add ( row.getKIndex());
				kGammaDb.add ( row.getKGamma());	
				kestIndexDb.add (row.getKestIndex());
    					
    				}
			
	    	sort(dateDb, idDb, kIndexDb, kGammaDb, kestIndexDb);
	    	
    			}

		List<GeoMagK3hr> k3hrAtPoint = retrieveSingleK3hr(dataURI, epTime);
		    	
		if (k3hrAtPoint == null || k3hrAtPoint.size() == 0) {

			// calculate aRunning, aFinalRunning			
			// only need first 7 k
	    	int sum = 0;
			for (int k = 0; k < kestIndexDb.size(); k++) {
				int a_est = CalcKp.getAest(stationCode, kestIndexDb.get(k));
				sum += a_est;
			}
			sum += CalcKp.getAest(stationCode, kest_index);
			aRun = (int) sum / (kestIndexDb.size()+1);  
			
			recK3hr.setRefTime(epTime);
    			recK3hr.setLastUpdate(Calendar.getInstance().getTime());
    			recK3hr.setStationCode(stationCode);
			recK3hr.setKestIndex(kest_index);
	    	recK3hr.setKestReal(kest_real);
	    	recK3hr.setKestGamma(kest_gamma);
	    	recK3hr.setARunning(aRun);
	    	
    			GeoMagK3hrDao k3hrDao = new GeoMagK3hrDao();
				k3hrDao.persist(recK3hr);
		}

		else {
			GeoMagK3hr row = (GeoMagK3hr) k3hrAtPoint.get(0);				
			int idCurr = row.getId();				
			int kIndexCurr = row.getKIndex();
			float kGammaCurr =  row.getKGamma();
			float kRealCurr =  row.getKReal();
			int aFinalRunCurr = row.getAFinalRunning();
			int manualCurr = row.getIsManual();
			
			if ((hour+1)%3 == 0 && (min+1)%60 == 0) {
						        	
	        	// calculate aFinalRunning, aFinalRunning
				int sumEnd = 0;					
				for (int k = 0; k < kIndexDb.size(); k++) {
					int a_est = CalcKp.getAest(stationCode, kIndexDb.get(k));
					sumEnd += a_est;
				}
				
//				if ((kIndexCurr == MISSING_INT || kIndexCurr == 0) &&  //manual=0
//		        		(kGammaCurr == MISSING_INT || kGammaCurr == 0)  )
				if (manualCurr == 0)
					sumEnd += CalcKp.getAest(stationCode, kest_index);
				else
					sumEnd += CalcKp.getAest(stationCode, kIndexCurr);
				
				int aFinalRun = (int) sumEnd / (kIndexDb.size()+1);  
				
				recK3hr.setAFinalRunning(aFinalRun);
				recK3hr.setIsManual(manualCurr);				
//				if (kIndexCurr == MISSING_INT || kIndexCurr == 0)  //manual=0
//					recK3hr.setKIndex(kest_index);
//				else
//					recK3hr.setKIndex(kIndexCurr); 
				
				if (manualCurr == 0) {
					recK3hr.setKIndex(kest_index);
					recK3hr.setKReal(kest_real);
					recK3hr.setKGamma(kest_gamma);					
			}
				else {
					
					recK3hr.setKIndex(kIndexCurr); 
					recK3hr.setKReal(kRealCurr);
					recK3hr.setKGamma(kGammaCurr);
				}
				    
		}
			else {
	        	
        		recK3hr.setKIndex(kIndexCurr);       	
        		recK3hr.setKReal(kRealCurr);       	
        		recK3hr.setKGamma(kGammaCurr);        	
        		recK3hr.setAFinalRunning(aFinalRunCurr);
        		recK3hr.setIsManual(manualCurr);
			}

			// calculate aRunning, aFinalRunning			
			// only need first 7 k
	    	int sum = 0;
			for (int k = 0; k < kestIndexDb.size(); k++) {
				int a_est = CalcKp.getAest(stationCode, kestIndexDb.get(k));
				sum += a_est;
			}
			sum += CalcKp.getAest(stationCode, kest_index);
			aRun = (int) sum / (kestIndexDb.size()+1);  
			
			
			if (idCurr != 0)
				recK3hr.setId(idCurr);				
			recK3hr.setRefTime(epTime);
    		recK3hr.setLastUpdate(Calendar.getInstance().getTime());
    		recK3hr.setStationCode(stationCode);
			recK3hr.setKestIndex(kest_index);
	    	recK3hr.setKestReal(kest_real);
        	recK3hr.setKestGamma(kest_gamma);
        	recK3hr.setARunning(aRun);
        	
	        GeoMagK3hrDao k3hrDao = new GeoMagK3hrDao();
			k3hrDao.persist(recK3hr);
	}

	}	
}