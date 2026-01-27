#!/usr/bin/env python3
"""
Script to update PDF metadata title
Requires: PyPDF2 or pypdf library
Install with: pip install pypdf
"""

import sys
import os

try:
    from pypdf import PdfReader, PdfWriter
except ImportError:
    try:
        from PyPDF2 import PdfReader, PdfWriter
    except ImportError:
        print("Error: pypdf library not found.")
        print("Please install it with: pip install pypdf")
        sys.exit(1)

# File paths
pdf_path = r"c:\Users\Rahul\Downloads\Utkalitta Day Care\utkalitaa.gravitones.com\utkalitaa.gravitones.com\Data\Admission.pdf"
output_path = r"c:\Users\Rahul\Downloads\Utkalitta Day Care\utkalitaa.gravitones.com\utkalitaa.gravitones.com\Data\Admission_updated.pdf"

# New title
new_title = "Day Care Admission Form"

try:
    # Read the PDF
    print(f"Reading PDF: {pdf_path}")
    reader = PdfReader(pdf_path)
    writer = PdfWriter()
    
    # Copy all pages
    for page in reader.pages:
        writer.add_page(page)
    
    # Update metadata
    metadata = reader.metadata
    writer.add_metadata({
        '/Title': new_title,
        '/Author': metadata.get('/Author', 'Sonu Bhattaray'),
        '/Creator': metadata.get('/Creator', 'Canva'),
        '/Producer': 'Updated by Python Script',
    })
    
    # Write the updated PDF
    print(f"Writing updated PDF: {output_path}")
    with open(output_path, 'wb') as output_file:
        writer.write(output_file)
    
    print("\n✓ PDF metadata updated successfully!")
    print(f"✓ New title: {new_title}")
    print(f"\nNext steps:")
    print(f"1. Check the updated file: {output_path}")
    print(f"2. If everything looks good, replace the original file")
    print(f"3. Or rename Admission_updated.pdf to Admission.pdf")
    
except FileNotFoundError:
    print(f"Error: PDF file not found at {pdf_path}")
    sys.exit(1)
except Exception as e:
    print(f"Error: {e}")
    sys.exit(1)
