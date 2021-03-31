import json

with open("curves.json", "r") as file:
    data = json.load(file)

for key in data:
    data[key] = [round(x, 4) for x in data[key]]

with open("curves.json", "w") as file:
    file.write('{\n')
    for idx, key in enumerate(data):
        file.write('  "{}": '.format(key))
        file.write(json.dumps(data[key], sort_keys=True))
        if (idx < len(data) - 1):
            file.write(',\n')
    file.write('\n}')
