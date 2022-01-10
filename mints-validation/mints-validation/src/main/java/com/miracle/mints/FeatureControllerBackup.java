//package com.miracle.mints;
//
//import java.io.File;
//import java.io.IOException;
//import java.net.URI;
//import java.net.URISyntaxException;
//import java.nio.file.Files;
//import java.nio.file.Path;
//import java.nio.file.Paths;
//import java.util.HashMap;
//import java.util.List;
//import java.util.Map;
//import java.util.stream.Collectors;
//
//import org.apache.commons.io.FileUtils;
//import org.jsoup.Jsoup;
//import org.jsoup.nodes.Document;
//import org.jsoup.nodes.Element;
//import org.jsoup.select.Elements;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.beans.factory.annotation.Value;
//import org.springframework.http.HttpStatus;
//import org.springframework.http.MediaType;
//import org.springframework.http.ResponseEntity;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RestController;
//import org.springframework.web.client.RestTemplate;
//
//@RestController
//@RequestMapping("/featureTest")
//public class FeatureControllerBackup {
//
//	@Value("${loadFeatureFilesApi}")
//	private String loadFeatureFilesApi;
//
//	@Autowired
//	RestTemplate restTemplate;
//
//	@Value("${featureFilesLocation}")
//	private String featureFilesLocation;
//
//	@Value("${testCasesdir}")
//	private String testCasesdir;
//
//	@Value("${resultPath}")
//	private String resultPath;
//
//	private static final String DOUBLE_QUOTE = "\"";
//
//	// healthCheck checking added By chandra mouli
//	/**
//	 * 
//	 * @return
//	 */
//	@GetMapping("/healthCheck")
//	public ResponseEntity<HashMap<String, String>> healthCheck() {
//
//		HashMap<String, String> map = new HashMap<>();
//		map.put("Status", "Up");
//
//		try {
//			return new ResponseEntity<>(map, HttpStatus.OK);
//		} catch (Exception e) {
//			return new ResponseEntity<>(null, HttpStatus.INTERNAL_SERVER_ERROR);
//		}
//	}
//
//	// Validated the feature files added By chandra mouli
//	
//	/**
//	 * 
//	 * @return
//	 * @throws IOException
//	 */
//	@RequestMapping(value = "/validateFeatureFiles", produces = MediaType.APPLICATION_JSON_VALUE)
//	public ResponseEntity<String> ValidateFeatureFiles() throws IOException {
//
//		FileUtils.copyDirectory(new File(featureFilesLocation), new File(testCasesdir));
//		List<File> deleteFiles = Files.list(Paths.get(testCasesdir)).map(Path::toFile).collect(Collectors.toList());
//		URI url;
//		String response = null;
//		String flag = "SUCCESS";
//		StringBuilder res = new StringBuilder();
//		HashMap<String, String> map = new HashMap<>();
//		HashMap<String, String> notNullMap = new HashMap<>();
//
//		File resultFile = new File(resultPath);
//		String content = FileUtils.readFileToString(resultFile);
//		HashMap<String, String> resultMap = null;
//		if (content != "" || content != null) {
//			resultMap = getResultMap(content);
//		}
//		try {
//			List<File> files = Files.list(Paths.get(featureFilesLocation)).map(Path::toFile)
//					.collect(Collectors.toList());
//			res.append("<html><body><table><tr style='background-color: #171817 ;color:white' ><th>Scenario Name</th><th>Status</th></tr>");
//			for (File file : files) {
//				url = new URI(
//						loadFeatureFilesApi + "FeatureFileName=" + file.getName() + "&featureId=5678");
//				response = restTemplate.getForObject(url, String.class);
//				String strs = response.substring(response.indexOf("<body>"), response.indexOf("</body>"))
//						.replace("<body>", "");
//
//				Document doc = Jsoup.parse(strs.trim());
//				Element table = doc.select("table").get(1);
//				Elements rows = table.select("tr");
//
//				for (int i = 0; i < rows.size(); i++) {
//					Element row = rows.get(i);
//					Elements td = row.select("td");
//					Elements th = row.select("th");
//					String thString = th.toString();
//					if (td.text().equals("SUCCESS") || td.text().equals("FAILURE")) {
//						String spanString = thString.substring(thString.indexOf("<span"), thString.indexOf("</span>"))
//								.concat("</span>");
//						map.put(Jsoup.parse(thString.replace(spanString, "")).text().trim(), td.text().trim());
//						notNullMap.put(Jsoup.parse(thString.replace(spanString, "")).text().trim(), td.text().trim());
//
//					}
//
//				}
//			}
////			for (Map.Entry<String, String> entry : resultMap.entrySet()) {
////				map.remove(entry.getKey());
////			}
//			
//		//	if(!map.isEmpty()) {
//			for (Map.Entry<String, String> entry : map.entrySet()) {
//				String key = entry.getKey().trim();
//				String value = entry.getValue();
//
//				if (value.equalsIgnoreCase("SUCCESS")) {
//					// flag = "SUCCESS";
//					res.append("<tr style=\'background-color: #a0dda0\' ><td>").append(key).append("</td><td>")
//							.append(value).append("</td></tr>");
//				} else {
//					flag = "FAIL";
//					res.append("<tr style=\'background-color: #ed8142\' ><td>").append(key).append("</td><td>")
//							.append(value).append("</td></tr>");
//				}
//			}
//		//	}
////			else {
////				for (Map.Entry<String, String> entry : notNullMap.entrySet()) {
////					String key = entry.getKey().trim();
////					String value = entry.getValue();
////
////					if (value.equalsIgnoreCase("SUCCESS")) {
////						// flag = "SUCCESS";
////						res.append("<tr style=\'background-color: #a0dda0\' ><td>").append(key).append("</td><td>")
////								.append(value).append("</td></tr>");
////					} else {
////						flag = "FAIL";
////						res.append("<tr style=\'background-color: #ed8142\' ><td>").append(key).append("</td><td>")
////								.append(value).append("</td></tr>");
////					}
////				}
//		//	}
//			res.append("</table>" + "</body>" + "</html>");
//
//		} catch (URISyntaxException e) {
//			e.printStackTrace();
//			for (File file : deleteFiles) {
//				file.delete();
//			}
//			String output="{\"result\":" + DOUBLE_QUOTE + flag + DOUBLE_QUOTE + " ,\"output\":" + DOUBLE_QUOTE + e.getMessage()
//			+ DOUBLE_QUOTE + "}";
//			return new ResponseEntity<>(output, HttpStatus.INTERNAL_SERVER_ERROR);
//		}
//		for (File file : deleteFiles) {
//			file.delete();
//		}
//		String output= "{\"result\":" + DOUBLE_QUOTE + flag + DOUBLE_QUOTE + " ,\"output\":" + DOUBLE_QUOTE + res.toString()
//				+ DOUBLE_QUOTE + "}";
//		return new ResponseEntity<>(output, HttpStatus.OK);
//
//	}
//
//	/**
//	 * 
//	 * @param conent
//	 * @return
//	 */
//	public static HashMap<String, String> getResultMap(String conent) {
//		HashMap<String, String> map = new HashMap<>();
//		HashMap<Integer, List> listMap = new HashMap<>();
//
//		try {
//			String strs = conent.substring(conent.indexOf("<body>"), conent.indexOf("</body>")).replace("<body>", "");
//			Document doc = Jsoup.parse(strs.trim());
//			Element table = doc.select("table").get(1);
//			Elements rows = table.select("tr");
//			for (int i = 0; i < rows.size(); i++) {
//				Element row = rows.get(i);
//				Elements td = row.select("td");
//				Elements th = row.select("th");
//				String thString = th.toString();
//				if (td.text().equals("SUCCESS") || td.text().equals("FAILURE")) {
//					String spanString = thString.substring(thString.indexOf("<span"), thString.indexOf("</span>"))
//							.concat("</span>");
//					map.put(Jsoup.parse(thString.replace(spanString, "")).text().trim(), td.text().trim());
//
//				}
//
//			}
//			return map;
//
//		} catch (Exception e) {
//			e.printStackTrace();
//			return map;
//		}
//	}
//	
//	/**
//	 * 
//	 * @param map
//	 * @return
//	 */
//	public static  HashMap<String, String> createHTMLTable(HashMap<String, String> map ) {
//		StringBuilder res = new StringBuilder();
//		res.append("<html><body><table><tr><th>Scenario Name</th><th>Status</th></tr>");
//		HashMap<String, String>  resultMap= new HashMap<>();
//		String flag = "SUCCESS";
//		try {
//			for (Map.Entry<String, String> entry : map.entrySet()) {
//				String key = entry.getKey().trim();
//				String value = entry.getValue();
//
//				if (value.equalsIgnoreCase("SUCCESS")) {
//					res.append("<tr style=\'background-color: #a0dda0\' ><td>").append(key).append("</td><td>")
//							.append(value).append("</td></tr>");
//				} else {
//					flag = "FAIL";
//					res.append("<tr style=\'background-color: #ed8142\' ><td>").append(key).append("</td><td>")
//							.append(value).append("</td></tr>");
//				}
//			}
//			res.append("</table>" + "</body>" + "</html>");
//			resultMap.put(flag, res.toString());
//			return resultMap;
//		} catch (Exception e) {
//			e.printStackTrace();
//			return resultMap;
//		}
//	}
//}
