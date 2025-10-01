import email
import os
import csv
from email.header import decode_header
from pathlib import Path


class EMLExtractor:
    def __init__(self):
        self.extracted_data = []

    def decode_mime_words(self, s):
        """Decode MIME encoded words in headers"""
        if s is None:
            return ""

        decoded_parts = decode_header(s)
        decoded_string = ""

        for part, encoding in decoded_parts:
            if isinstance(part, bytes):
                if encoding:
                    decoded_string += part.decode(encoding)
                else:
                    decoded_string += part.decode('utf-8', errors='ignore')
            else:
                decoded_string += part

        return decoded_string.strip()

    def extract_body(self, msg):
        """Extract email body in human-readable format"""
        body = ""
        html_body = ""

        if msg.is_multipart():
            for part in msg.walk():
                content_type = part.get_content_type()
                content_disposition = str(part.get("Content-Disposition"))

                # Skip attachments
                if "attachment" in content_disposition:
                    continue

                # Get text content
                if content_type == "text/plain":
                    try:
                        body = part.get_payload(decode=True).decode(
                            'utf-8', errors='ignore')
                        break  # Prefer plain text - most human readable
                    except:
                        continue
                elif content_type == "text/html":
                    try:
                        html_body = part.get_payload(
                            decode=True).decode('utf-8', errors='ignore')
                    except:
                        continue
        else:
            # Single part message
            content_type = msg.get_content_type()
            try:
                if content_type == "text/plain":
                    body = msg.get_payload(decode=True).decode(
                        'utf-8', errors='ignore')
                elif content_type == "text/html":
                    html_body = msg.get_payload(decode=True).decode(
                        'utf-8', errors='ignore')
                else:
                    body = str(msg.get_payload())
            except:
                body = str(msg.get_payload())

        # If we only have HTML, convert it to readable text
        if not body and html_body:
            body = self.html_to_text(html_body)

        return body.strip()

    def html_to_text(self, html_content):
        """Convert HTML to human-readable plain text"""
        import re

        # Remove script and style elements
        html_content = re.sub(
            r'<script[^>]*>.*?</script>', '', html_content, flags=re.DOTALL | re.IGNORECASE)
        html_content = re.sub(
            r'<style[^>]*>.*?</style>', '', html_content, flags=re.DOTALL | re.IGNORECASE)

        # Replace common HTML elements with readable equivalents
        html_content = re.sub(r'<br[^>]*>', '\n',
                              html_content, flags=re.IGNORECASE)
        html_content = re.sub(r'<p[^>]*>', '\n\n',
                              html_content, flags=re.IGNORECASE)
        html_content = re.sub(r'</p>', '', html_content, flags=re.IGNORECASE)
        html_content = re.sub(r'<div[^>]*>', '\n',
                              html_content, flags=re.IGNORECASE)
        html_content = re.sub(r'</div>', '', html_content, flags=re.IGNORECASE)

        # Remove all other HTML tags
        html_content = re.sub(r'<[^>]+>', '', html_content)

        # Decode HTML entities
        import html
        html_content = html.unescape(html_content)

        # Clean up whitespace
        # Multiple newlines to double
        html_content = re.sub(r'\n\s*\n', '\n\n', html_content)
        # Multiple spaces to single
        html_content = re.sub(r'[ \t]+', ' ', html_content)

        return html_content.strip()

    def extract_from_eml(self, file_path):
        """Extract from, subject, and body from a single .eml file"""
        try:
            with open(file_path, 'rb') as f:
                msg = email.message_from_bytes(f.read())

    def extract_readable_from(self, from_header):
        """Extract human-readable from field"""
        if not from_header:
            return ""

        # Decode MIME encoding
        decoded = self.decode_mime_words(from_header)

        # Extract name and email if both present
        import re
        match = re.match(r'^ (.*?)\s*<(.+?) >

            # Extract and decode headers for human readability
            from_header=self.extract_readable_from(msg.get('From', ''))
            subject=self.decode_mime_words(msg.get('Subject', ''))

            # Extract body in human-readable format
            body=self.extract_body(msg)
                'file_path': str(file_path),
                'from': from_header,
                'subject': subject,
                'body': body
            }

        except Exception as e:
            print(f"Error processing {file_path}: {str(e)}")
            return None

    def process_directory(self, directory_path):
        """Process all .eml files in a directory"""
        directory = Path(directory_path)
        eml_files = list(directory.glob("*.eml"))

        if not eml_files:
            print(f"No .eml files found in {directory_path}")
            return

        print(f"Found {len(eml_files)} .eml files to process...")

        for eml_file in eml_files:
            print(f"Processing: {eml_file.name}")
            result = self.extract_from_eml(eml_file)
            if result:
                self.extracted_data.append(result)

        print(f"Successfully processed {len(self.extracted_data)} files")

    def save_to_csv(self, output_file="extracted_emails.csv"):
        """Save extracted data to CSV file"""
        if not self.extracted_data:
            print("No data to save")
            return

        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            fieldnames = ['file_path', 'from', 'subject', 'body']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

            writer.writeheader()
            for row in self.extracted_data:
                writer.writerow(row)

        print(f"Data saved to {output_file}")

    def save_to_json(self, output_file="extracted_emails.json"):
        """Save extracted data to JSON file"""
        import json

        if not self.extracted_data:
            print("No data to save")
            return

        with open(output_file, 'w', encoding='utf-8') as jsonfile:
            json.dump(self.extracted_data, jsonfile,
                      indent=2, ensure_ascii=False)

        print(f"Data saved to {output_file}")

    def print_summary(self):
        """Print a summary of extracted data"""
        if not self.extracted_data:
            print("No data extracted")
            return

        print(f"\n=== EXTRACTION SUMMARY ===")
        print(f"Total emails processed: {len(self.extracted_data)}")
        print(f"\nFirst few entries:")

        for i, data in enumerate(self.extracted_data[:3]):
            print(f"\n--- Email {i+1} ---")
            print(f"File: {Path(data['file_path']).name}")
            print(f"From: {data['from'][:100]}...")
            print(f"Subject: {data['subject'][:100]}...")
            print(f"Body preview: {data['body'][:200]}...")


def main():
    """Main function to demonstrate usage"""
    extractor = EMLExtractor()

    # Example usage - modify these paths as needed

    # Process a single file
    # result = extractor.extract_from_eml("path/to/your/email.eml")
    # if result:
    #     print(f"From: {result['from']}")
    #     print(f"Subject: {result['subject']}")
    #     print(f"Body: {result['body'][:200]}...")

    # Process all .eml files in a directory
    directory_path = input(
        "Enter the directory path containing .eml files: ").strip()

    if not os.path.exists(directory_path):
        print("Directory not found!")
        return

    extractor.process_directory(directory_path)

    if extractor.extracted_data:
        # Show summary
        extractor.print_summary()

        # Save results
        save_format = input("\nSave as (csv/json/both): ").strip().lower()

        if save_format in ['csv', 'both']:
            extractor.save_to_csv()

        if save_format in ['json', 'both']:
            extractor.save_to_json()


if __name__ == "__main__":
    main()
, decoded.strip())
        if match:
            name = match.group(1).strip().strip('"\'')
            email = match.group(2).strip()
            if name:
                return f"{name} <{email}>"
            else:
                return email
        else:
            return decoded.strip()

            # Extract body
            body = self.extract_body(msg)

            return {
                'file_path': str(file_path),
                'from': from_header,
                'subject': subject,
                'body': body
            }
            
        except Exception as e:
            print(f"Error processing {file_path}: {str(e)}")
            return None
    
    def process_directory(self, directory_path):
        """Process all .eml files in a directory"""
        directory = Path(directory_path)
        eml_files = list(directory.glob("*.eml"))
        
        if not eml_files:
            print(f"No .eml files found in {directory_path}")
            return
        
        print(f"Found {len(eml_files)} .eml files to process...")
        
        for eml_file in eml_files:
            print(f"Processing: {eml_file.name}")
            result = self.extract_from_eml(eml_file)
            if result:
                self.extracted_data.append(result)
        
        print(f"Successfully processed {len(self.extracted_data)} files")
    
    def save_to_csv(self, output_file="extracted_emails.csv"):
        """Save extracted data to CSV file"""
        if not self.extracted_data:
            print("No data to save")
            return
        
        with open(output_file, 'w', newline='', encoding='utf-8') as csvfile:
            fieldnames = ['file_path', 'from', 'subject', 'body']
            writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
            
            writer.writeheader()
            for row in self.extracted_data:
                writer.writerow(row)
        
        print(f"Data saved to {output_file}")
    
    def save_to_json(self, output_file="extracted_emails.json"):
        """Save extracted data to JSON file"""
        import json
        
        if not self.extracted_data:
            print("No data to save")
            return
        
        with open(output_file, 'w', encoding='utf-8') as jsonfile:
            json.dump(self.extracted_data, jsonfile, indent=2, ensure_ascii=False)
        
        print(f"Data saved to {output_file}")
    
    def print_summary(self):
        """Print a summary of extracted data"""
        if not self.extracted_data:
            print("No data extracted")
            return
        
        print(f"\n=== EXTRACTION SUMMARY ===")
        print(f"Total emails processed: {len(self.extracted_data)}")
        print(f"\nFirst few entries:")
        
        for i, data in enumerate(self.extracted_data[:3]):
            print(f"\n--- Email {i+1} ---")
            print(f"File: {Path(data['file_path']).name}")
            print(f"From: {data['from'][:100]}...")
            print(f"Subject: {data['subject'][:100]}...")
            print(f"Body preview: {data['body'][:200]}...")


def main():
    """Main function to demonstrate usage"""
    extractor = EMLExtractor()
    
    # Example usage - modify these paths as needed
    
    # Process a single file
    # result = extractor.extract_from_eml("path/to/your/email.eml")
    # if result:
    #     print(f"From: {result['from']}")
    #     print(f"Subject: {result['subject']}")
    #     print(f"Body: {result['body'][:200]}...")
    
    # Process all .eml files in a directory
    directory_path = input("Enter the directory path containing .eml files: ").strip()
    
    if not os.path.exists(directory_path):
        print("Directory not found!")
        return
    
    extractor.process_directory(directory_path)
    
    if extractor.extracted_data:
        # Show summary
        extractor.print_summary()
        
        # Save results
        save_format = input("\nSave as (csv/json/both): ").strip().lower()
        
        if save_format in ['csv', 'both']:
            extractor.save_to_csv()
        
        if save_format in ['json', 'both']:
            extractor.save_to_json()


if __name__ == "__main__":
    main()