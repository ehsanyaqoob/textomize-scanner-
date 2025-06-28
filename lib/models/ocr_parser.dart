// import 'dart:io';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:textomize/core/exports.dart';

// class OCRDataParser {
//   final Map<String, RegExp> fieldPatterns;
//   final Map<String, dynamic> fieldValidators;
//   final double minimumConfidence;

//   OCRDataParser({
//     required this.fieldPatterns,
//     required this.fieldValidators,
//     this.minimumConfidence = 0.7, // Confidence threshold for accepting OCR results
//   });

//   Future<Map<String, dynamic>> parseFromImage(File imageFile) async {
//     try {
//       final inputImage = InputImage.fromFile(imageFile);
//       final textRecognizer = GoogleMlKit.vision.textRecognizer();
//       final RecognizedText recognisedText = await textRecognizer.processImage(inputImage);

//       // Extract lines with confidence scores
//       final linesWithConfidence = _extractLinesWithConfidence(recognisedText);
      
//       // First pass: Look for high-confidence labeled data
//       final extractedData = _extractLabeledDataWithConfidence(linesWithConfidence);

//       // Second pass: Look for patterns in remaining high-confidence text
//       _extractPatternsFromRemainingText(extractedData, linesWithConfidence);

//       // Third pass: Fallback to low-confidence text if needed
//       _fallbackToLowConfidenceText(extractedData, linesWithConfidence);

//       await textRecognizer.close();

//       // Validate and return the extracted data
//       return _validateExtractedData(extractedData);
//     } catch (e) {
//       debugPrint('OCR Parsing Error: $e');
//       rethrow;
//     }
//   }

//   List<MapEntry<String, double>> _extractLinesWithConfidence(RecognizedText text) {
//     final lines = <MapEntry<String, double>>[];
    
//     for (final block in text.blocks) {
//       for (final line in block.lines) {
//         // Calculate average confidence for the line
//         double totalConfidence = 0;
//         int elementCount = 0;
        
//         for (final element in line.elements) {
//           totalConfidence += element.confidence!;
//           elementCount++;
//         }
        
//         final averageConfidence = elementCount > 0 ? totalConfidence / elementCount : 0;
//         lines.add(MapEntry(line.text.trim(), averageConfidence.toDouble()));
//       }
//     }
    
//     return lines;
//   }

//   Map<String, dynamic> _extractLabeledDataWithConfidence(
//       List<MapEntry<String, double>> lines) {
//     final extractedData = <String, dynamic>{};
    
//     for (final field in fieldPatterns.keys) {
//       final labelVariations = _getLabelVariations(field);
      
//       for (final lineEntry in lines) {
//         final line = lineEntry.key.toLowerCase();
//         final confidence = lineEntry.value;
        
//         if (confidence < minimumConfidence) continue;
        
//         for (final label in labelVariations) {
//           if (line.contains(label.toLowerCase())) {
//             final value = line.replaceAll(RegExp(label, caseSensitive: false), '')
//                 .replaceAll(RegExp(r'[:;]'), '')
//                 .trim();
            
//             final converted = _convertValue(field, value);
//             if (converted != null && _validateField(field, converted)) {
//               extractedData[field] = converted;
//               break;
//             }
//           }
//         }
//       }
//     }
    
//     return extractedData;
//   }

//   void _extractPatternsFromRemainingText(
//       Map<String, dynamic> extractedData,
//       List<MapEntry<String, double>> lines) {
//     for (final field in fieldPatterns.keys) {
//       if (extractedData.containsKey(field)) continue;
      
//       final pattern = fieldPatterns[field]!;
      
//       for (final lineEntry in lines) {
//         final line = lineEntry.key;
//         final confidence = lineEntry.value;
        
//         if (confidence < minimumConfidence) continue;
        
//         final match = pattern.firstMatch(line);
//         if (match != null) {
//           final value = _convertValue(field, match.group(0)!);
//           if (value != null && _validateField(field, value)) {
//             extractedData[field] = value;
//             break;
//           }
//         }
//       }
//     }
//   }

//   void _fallbackToLowConfidenceText(
//       Map<String, dynamic> extractedData,
//       List<MapEntry<String, double>> lines) {
//     for (final field in fieldPatterns.keys) {
//       if (extractedData.containsKey(field)) continue;
      
//       final pattern = fieldPatterns[field]!;
      
//       // Try more lenient matching for low-confidence text
//       for (final lineEntry in lines) {
//         final line = lineEntry.key;
        
//         // Special handling for registration numbers
//         if (field == 'regNo') {
//           final relaxedPattern = RegExp(r'(\d{1,2}[-\s]?[a-zA-Z]{3,4}[-\s]?\d{3})');
//           final relaxedMatch = relaxedPattern.firstMatch(line);
//           if (relaxedMatch != null) {
//             // Clean up the matched text
//             final cleaned = relaxedMatch.group(0)!
//                 .replaceAll(' ', '')
//                 .replaceAll('-', '')
//                 .toUpperCase();
            
//             if (cleaned.length >= 8) { // Minimum length for ARID numbers
//               extractedData[field] = cleaned;
//               break;
//             }
//           }
//         }
        
//         // For marks, look for numbers near keywords
//         if (field == 'marks') {
//           if (line.toLowerCase().contains('mark') || 
//               line.toLowerCase().contains('score')) {
//             final numbers = RegExp(r'(\d{1,3})').allMatches(line);
//             if (numbers.isNotEmpty) {
//               final value = int.tryParse(numbers.first.group(0)!);
//               if (value != null && value >= 0 && value <= 100) {
//                 extractedData[field] = value;
//                 break;
//               }
//             }
//           }
//         }
//       }
//     }
//   }

//   Map<String, dynamic> _validateExtractedData(Map<String, dynamic> data) {
//     final validatedData = <String, dynamic>{};
    
//     for (final field in fieldValidators.keys) {
//       if (!data.containsKey(field) || !_validateField(field, data[field]!)) {
//         throw Exception("Required field '$field' not found or invalid");
//       }
//       validatedData[field] = data[field];
//     }
    
//     return validatedData;
//   }

//   List<String> _getLabelVariations(String field) {
//     switch (field.toLowerCase()) {
//       case 'regno':
//         return ['arid no', 'registration', 'reg no', 'student id', 'id', 'roll no', 'roll number'];
//       case 'name':
//         return ['name', 'student name', 'full name', 'student'];
//       case 'marks':
//         return ['marks', 'score', 'total', 'obtained', 'mark', 'result'];
//       default:
//         return [field];
//     }
//   }

//   dynamic _convertValue(String field, String value) {
//     try {
//       if (fieldValidators[field] is bool Function(String)) {
//         return value.trim();
//       } else if (fieldValidators[field] is bool Function(num)) {
//         // Handle common OCR mistakes in numbers
//         final cleaned = value
//             .replaceAll('O', '0')
//             .replaceAll('o', '0')
//             .replaceAll('l', '1')
//             .replaceAll('I', '1')
//             .replaceAll('B', '8')
//             .replaceAll(' ', '');
//         return double.tryParse(cleaned) ?? int.tryParse(cleaned);
//       }
//       return value.trim();
//     } catch (e) {
//       debugPrint('Value conversion error for $field: $e');
//       return null;
//     }
//   }

//   bool _validateField(String field, dynamic value) {
//     if (fieldValidators[field] == null) return true;
    
//     try {
//       return fieldValidators[field]!(value);
//     } catch (e) {
//       debugPrint('Validation error for $field: $e');
//       return false;
//     }
//   }
// }

import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:textomize/core/exports.dart';

class OCRDataParser {
  final Map<String, RegExp> fieldPatterns;
  final Map<String, dynamic> fieldValidators;

  OCRDataParser({
    required this.fieldPatterns,
    required this.fieldValidators,
  });

  Future<Map<String, dynamic>> parseFromImage(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);
      final textRecognizer = TextRecognizer();
      final RecognizedText recognisedText = await textRecognizer.processImage(inputImage);

      // Extract all text lines
      final textLines = recognisedText.blocks
          .expand((block) => block.lines)
          .map((line) => line.text)
          .toList();

      debugPrint('OCR extracted text: $textLines');

      // First try to find labeled data
      final extractedData = _extractLabeledData(textLines);

      // Then try to find unlabeled patterns
      for (final field in fieldPatterns.keys) {
        if (!extractedData.containsKey(field)) {
          extractedData[field] = _extractUnlabeledData(field, textLines);
        }
      }

      await textRecognizer.close();

      // Validate extracted data
      for (final field in fieldValidators.keys) {
        if (extractedData[field] == null || 
            !_validateField(field, extractedData[field]!)) {
          throw Exception("Required field '$field' not found or invalid");
        }
      }

      return extractedData;
    } catch (e) {
      debugPrint('OCR Parsing Error: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _extractLabeledData(List<String> textLines) {
    final extractedData = <String, dynamic>{};

    for (final line in textLines) {
      final lineText = line.toLowerCase();

      for (final field in fieldPatterns.keys) {
        if (extractedData.containsKey(field)) continue;

        final labelVariations = _getLabelVariations(field);
        
        for (final label in labelVariations) {
          if (lineText.contains(label.toLowerCase())) {
            // Try to extract the value using the field pattern
            final pattern = fieldPatterns[field]!;
            final match = pattern.firstMatch(line);
            
            if (match != null && match.groupCount >= 1) {
              extractedData[field] = _convertValue(field, match.group(1)!);
              break;
            }
          }
        }
      }
    }

    return extractedData;
  }

  dynamic _extractUnlabeledData(String field, List<String> textLines) {
    final pattern = fieldPatterns[field]!;
    
    for (final line in textLines) {
      final match = pattern.firstMatch(line);
      if (match != null && match.groupCount >= 1) {
        return _convertValue(field, match.group(1)!);
      }
    }
    
    return null;
  }


  List<String> _getLabelVariations(String field) {
    switch (field.toLowerCase()) {
      case 'regno':
        return ['arid no', 'registration', 'reg no', 'student id', 'id'];
      case 'marks':
        return ['marks', 'score', 'total', 'obtained'];
      default:
        return [field];
    }
  }

  dynamic _convertValue(String field, String value) {
    try {
      if (fieldValidators[field] is bool Function(String)) {
        return value.trim();
      } else if (fieldValidators[field] is bool Function(num)) {
        // Handle common OCR mistakes in numbers
        final cleaned = value
            .replaceAll('O', '0')
            .replaceAll('o', '0')
            .replaceAll('l', '1')
            .replaceAll('I', '1')
            .replaceAll('B', '8')
            .replaceAll(' ', '');
        return double.tryParse(cleaned) ?? int.tryParse(cleaned);
      }
      return value.trim();
    } catch (e) {
      debugPrint('Value conversion error for $field: $e');
      return null;
    }
  }

  bool _validateField(String field, dynamic value) {
    if (fieldValidators[field] == null) return true;
    
    try {
      return fieldValidators[field]!(value);
    } catch (e) {
      debugPrint('Validation error for $field: $e');
      return false;
    }
  }
}