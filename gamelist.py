import xml.etree.ElementTree as ET
import sys

# check if "BD PROCHOT" Element is already present in gamelist.xml
def in_gamelist(xml_filepath: str, name: str):
    tree = ET.parse(xml_filepath)
    root = tree.getroot()

    match = False
    for child in root:
        if child.findtext('name') == name:
            match = True
            break
    return match

# add BD PROCHOT element to gamelist.xml
def modify_gamelist(xml_filepath: str, path: str, name: str, image: str):
    tree = ET.parse(xml_filepath)
    root = tree.getroot()

    # <game>
    #   <path>path</path>
    #   <name>name</name>
    #   <image>image</image>
    # </game>
    game = ET.Element('game')
    game_path = ET.SubElement(game, 'path')
    game_path.text = path
    game_name = ET.SubElement(game, 'name')
    game_name.text = name
    game_image = ET.SubElement(game, 'image')
    game_image.text = image
    root.append(game)

    # pretty write to file
    tree = ET.ElementTree(root)
    ET.indent(tree, space="\t", level=0)
    tree.write(xml_filepath, encoding="utf-8")

def main():
    xml_filepath = '/userdata/roms/ports/gamelist.xml'
    path = './bd_prochot_runner.sh'
    name = 'BD-Prochot'
    image = './images/bd_prochot.png'

    if not in_gamelist(xml_filepath, name):
        sys.stdout.write(f"############ modifying {xml_filepath} ############\n")
        modify_gamelist(xml_filepath, path, name, image)
        sys.stdout.write("################ D O N E ################\n\n")
    else:
        sys.stdout.write(f"############ {xml_filepath} already contains an element named: {name} ############\n")
        sys.stdout.write(f"############ {xml_filepath} will not be modified ############\n\n")

if __name__ == '__main__':
    main()
