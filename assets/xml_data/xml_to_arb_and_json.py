import os
import json
import xml.etree.ElementTree as ET

def convert_xml_to_arb_and_json(root_dir):
    # Directory to save converted files
    output_dir = os.path.join(root_dir, "converted")
    os.makedirs(output_dir, exist_ok=True)

    # Directory to save ARB files
    arb_dir = os.path.join(output_dir, "localisation")
    os.makedirs(arb_dir, exist_ok=True)

    # Directory to save JSON files
    json_dir = os.path.join(output_dir, "categories")
    os.makedirs(json_dir, exist_ok=True)

    # Walking through all subdirectories in root_dir
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file == "strings.xml" or file == "categories.xml":
                lang = root[-2:]  # Extracting the last 2 characters from the root as the language code

                # Parsing the XML file
                tree = ET.parse(os.path.join(root, file))
                root_element = tree.getroot()

                data = {}

                if file == "strings.xml":
                    # Process strings.xml
                    for child in root_element:
                        name = child.attrib.get('name')
                        text = child.text.strip() if child.text is not None else ""
                        data[name] = text

                    # Creating and writing .arb file
                    with open(os.path.join(arb_dir, f"app_{lang}.arb"), "w", encoding="utf-8") as output_file:
                        json.dump(data, output_file, ensure_ascii=False, indent=4)

                    print(f"Converted strings.xml for {lang} to ARB format at {arb_dir}/strings_{lang}.arb")
                elif file == "categories.xml":
                    # Process categories.xml
                    for child in root_element:
                        name = child.attrib.get('name')
                        items = [item.text.strip() for item in child.findall("item")]
                        # Check if each item contains "@drawable/" and remove it if it does
                        items = [item.replace("@drawable/", "") if "@drawable/" in item else item for item in items]
                        data[name] = items

                    # Creating and writing .json file
                    with open(os.path.join(json_dir, f"categories_{lang}.json"), "w", encoding="utf-8") as output_file:
                        json.dump(data, output_file, ensure_ascii=False, indent=4)

                    print(f"Converted categories.xml for {lang} to JSON format at {json_dir}/categories_{lang}.json")

if __name__ == "__main__":
    convert_xml_to_arb_and_json(os.getcwd())
