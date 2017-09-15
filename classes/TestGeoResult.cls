@IsTest (SeeAllData=true)
public with sharing class TestGeoResult {


	static testMethod void testParse() {
		String json = '{'+
		'   \"results\" : ['+
		'      {'+
		'         \"address_components\" : ['+
		'            {'+
		'               \"long_name\" : \"00187\",'+
		'               \"short_name\" : \"00187\",'+
		'               \"types\" : [ \"postal_code\" ]'+
		'            },'+
		'            {'+
		'               \"long_name\" : \"Rome\",'+
		'               \"short_name\" : \"Rome\",'+
		'               \"types\" : [ \"locality\", \"political\" ]'+
		'            },'+
		'            {'+
		'               \"long_name\" : \"Rome\",'+
		'               \"short_name\" : \"RM\",'+
		'               \"types\" : [ \"administrative_area_level_2\", \"political\" ]'+
		'            },'+
		'            {'+
		'               \"long_name\" : \"Lazio\",'+
		'               \"short_name\" : \"Lazio\",'+
		'               \"types\" : [ \"administrative_area_level_1\", \"political\" ]'+
		'            },'+
		'            {'+
		'               \"long_name\" : \"Italy\",'+
		'               \"short_name\" : \"IT\",'+
		'               \"types\" : [ \"country\", \"political\" ]'+
		'            }'+
		'         ],'+
		'         \"formatted_address\" : \"00187 Rome, Italy\",'+
		'         \"geometry\" : {'+
		'            \"bounds\" : {'+
		'               \"northeast\" : {'+
		'                  \"lat\" : 41.912979,'+
		'                  \"lng\" : 12.5015479'+
		'               },'+
		'               \"southwest\" : {'+
		'                  \"lat\" : 41.8945799,'+
		'                  \"lng\" : 12.47453'+
		'               }'+
		'            },'+
		'            \"location\" : {'+
		'               \"lat\" : 41.905116,'+
		'               \"lng\" : 12.4867883'+
		'            },'+
		'            \"location_type\" : \"APPROXIMATE\",'+
		'            \"viewport\" : {'+
		'               \"northeast\" : {'+
		'                  \"lat\" : 41.912979,'+
		'                  \"lng\" : 12.5015479'+
		'               },'+
		'               \"southwest\" : {'+
		'                  \"lat\" : 41.8945799,'+
		'                  \"lng\" : 12.47453'+
		'               }'+
		'            }'+
		'         },'+
		'         \"types\" : [ \"postal_code\" ]'+
		'      },'+
		'      {'+
		'         \"address_components\" : ['+
		'            {'+
		'               \"long_name\" : \"00187\",'+
		'               \"short_name\" : \"00187\",'+
		'               \"types\" : [ \"postal_code\" ]'+
		'            },'+
		'            {'+
		'               \"long_name\" : \"Palanga\",'+
		'               \"short_name\" : \"Palanga\",'+
		'               \"types\" : [ \"locality\", \"political\" ]'+
		'            },'+
		'            {'+
		'               \"long_name\" : \"Palangos miesto savivaldybė\",'+
		'               \"short_name\" : \"Palangos m. sav.\",'+
		'               \"types\" : [ \"administrative_area_level_2\", \"political\" ]'+
		'            },'+
		'            {'+
		'               \"long_name\" : \"Klaipėda County\",'+
		'               \"short_name\" : \"Klaipėda County\",'+
		'               \"types\" : [ \"administrative_area_level_1\", \"political\" ]'+
		'            },'+
		'            {'+
		'               \"long_name\" : \"Lithuania\",'+
		'               \"short_name\" : \"LT\",'+
		'               \"types\" : [ \"country\", \"political\" ]'+
		'            }'+
		'         ],'+
		'         \"formatted_address\" : \"Palanga 00187, Lithuania\",'+
		'         \"geometry\" : {'+
		'            \"bounds\" : {'+
		'               \"northeast\" : {'+
		'                  \"lat\" : 55.957075,'+
		'                  \"lng\" : 21.0768019'+
		'               },'+
		'               \"southwest\" : {'+
		'                  \"lat\" : 55.955257,'+
		'                  \"lng\" : 21.0719858'+
		'               }'+
		'            },'+
		'            \"location\" : {'+
		'               \"lat\" : 55.9560379,'+
		'               \"lng\" : 21.0739764'+
		'            },'+
		'            \"location_type\" : \"APPROXIMATE\",'+
		'            \"viewport\" : {'+
		'               \"northeast\" : {'+
		'                  \"lat\" : 55.9575149802915,'+
		'                  \"lng\" : 21.0768019'+
		'               },'+
		'               \"southwest\" : {'+
		'                  \"lat\" : 55.9548170197085,'+
		'                  \"lng\" : 21.0719858'+
		'               }'+
		'            }'+
		'         },'+
		'         \"types\" : [ \"postal_code\" ]'+
		'      }'+
		'   ],'+
		'   \"status\" : \"OK\"'+
		'}';
		GeoResult geo = new GeoResult();

		geo = GeoResult.parse(json); 		
		System.assert(geo != null);
		
		if (geo.results != null) {
	        if (geo.results.size() > 0) {
		      
		       if (geo.results[0].address_components != null) {    	
		           	if (geo.results[0].address_components[0] != null) {
		           		//The GeoResult class knows how to get the information
		           		geo.getState(geo.results[0].address_components);
		           		geo.getState1(geo.results[0].address_components);
		           		geo.getState2(geo.results[0].address_components);
		           		geo.getState3(geo.results[0].address_components);
		           		geo.getState4(geo.results[0].address_components);
		           		geo.getLatitude(geo.results[0].Geometry);
		           		geo.getLongitude(geo.results[0].Geometry);
		           		geo.getCity(geo.results[0].address_components);
		           		geo.getPostal(geo.results[0].address_components);
		           		geo.getCountry(geo.results[0].address_components);
		           	}
		       }
		        	
	         }
		}		
	}
	
	
}