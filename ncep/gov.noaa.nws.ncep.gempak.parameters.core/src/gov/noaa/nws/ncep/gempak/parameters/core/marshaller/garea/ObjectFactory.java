//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, vJAXB 2.1.3 in JDK 1.6 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2009.09.29 at 09:13:32 AM EDT 
//


package gov.noaa.nws.ncep.gempak.parameters.core.marshaller.garea;

import javax.xml.bind.JAXBElement;
import javax.xml.bind.annotation.XmlElementDecl;
import javax.xml.bind.annotation.XmlRegistry;
import javax.xml.namespace.QName;


/**
 * This object contains factory methods for each 
 * Java content interface and Java element interface 
 * generated in the gov.noaa.nws.ncep.viz.tools.customdialog package. 
 * <p>An ObjectFactory allows you to programatically 
 * construct new instances of the Java representation 
 * for XML content. The Java representation of XML 
 * content can consist of schema derived interfaces 
 * and classes representing the binding of schema 
 * type definitions, element declarations and model 
 * groups.  Factory methods for each of these are 
 * provided in this class.
 * 
 */
@XmlRegistry
public class ObjectFactory {

    private final static QName _GeogCode_QNAME = new QName("", "geog_code");
    private final static QName _LowerLeftLon_QNAME = new QName("", "lower_left_lon");
    private final static QName _UpperRightLat_QNAME = new QName("", "upper_right_lat");
    private final static QName _GeogAreaName_QNAME = new QName("", "geog_area_name");
    private final static QName _LowerLeftLat_QNAME = new QName("", "lower_left_lat");
    private final static QName _MapProjectionString_QNAME = new QName("", "map_projection_string");
    private final static QName _CenterLat_QNAME = new QName("", "center_lat");
    private final static QName _UpperRightLon_QNAME = new QName("", "upper_right_lon");
    private final static QName _CenterLon_QNAME = new QName("", "center_lon");

    /**
     * Create a new ObjectFactory that can be used to create new instances of schema derived classes for package: gov.noaa.nws.ncep.viz.tools.customdialog
     * 
     */
    public ObjectFactory() {
    }

    /**
     * Create an instance of {@link GeogCodeList }
     * 
     */
    public GeogCodeList createGeogCodeList() {
        return new GeogCodeList();
    }

    /**
     * Create an instance of {@link GeographicalData }
     * 
     */
    public GeographicalData createGeographicalData() {
        return new GeographicalData();
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "geog_code")
    public JAXBElement<String> createGeogCode(String value) {
        return new JAXBElement<String>(_GeogCode_QNAME, String.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Float }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "lower_left_lon")
    public JAXBElement<Float> createLowerLeftLon(Float value) {
        return new JAXBElement<Float>(_LowerLeftLon_QNAME, Float.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Float }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "upper_right_lat")
    public JAXBElement<Float> createUpperRightLat(Float value) {
        return new JAXBElement<Float>(_UpperRightLat_QNAME, Float.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "geog_area_name")
    public JAXBElement<String> createGeogAreaName(String value) {
        return new JAXBElement<String>(_GeogAreaName_QNAME, String.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Float }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "lower_left_lat")
    public JAXBElement<Float> createLowerLeftLat(Float value) {
        return new JAXBElement<Float>(_LowerLeftLat_QNAME, Float.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link String }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "map_projection_string")
    public JAXBElement<String> createMapProjectionString(String value) {
        return new JAXBElement<String>(_MapProjectionString_QNAME, String.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Float }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "center_lat")
    public JAXBElement<Float> createCenterLat(Float value) {
        return new JAXBElement<Float>(_CenterLat_QNAME, Float.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Float }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "upper_right_lon")
    public JAXBElement<Float> createUpperRightLon(Float value) {
        return new JAXBElement<Float>(_UpperRightLon_QNAME, Float.class, null, value);
    }

    /**
     * Create an instance of {@link JAXBElement }{@code <}{@link Float }{@code >}}
     * 
     */
    @XmlElementDecl(namespace = "", name = "center_lon")
    public JAXBElement<Float> createCenterLon(Float value) {
        return new JAXBElement<Float>(_CenterLon_QNAME, Float.class, null, value);
    }

}