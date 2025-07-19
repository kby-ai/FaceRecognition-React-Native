class Person {
    constructor(name, faceJpg, templates) {
      this.name = name;
      this.faceJpg = faceJpg;
      this.templates = templates;
    }
  
    static fromMap(data) {
      return new Person(data.name, data.faceJpg, data.templates);
    }
  
    toMap() {
      return {
        name: this.name,
        faceJpg: this.faceJpg,
        templates: this.templates,
      };
    }
  }
