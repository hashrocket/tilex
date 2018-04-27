!(function() {
  if ('undefined' != typeof self && self.Prism && self.document) {
    if (!Prism.plugins.toolbar)
      return console.warn(
        'Show Languages plugin loaded before Toolbar plugin.'
      ), void 0;
    var e = {
      html: 'HTML',
      xml: 'XML',
      svg: 'SVG',
      mathml: 'MathML',
      css: 'CSS',
      clike: 'C-like',
      javascript: 'JavaScript',
      abap: 'ABAP',
      actionscript: 'ActionScript',
      apacheconf: 'Apache Configuration',
      apl: 'APL',
      applescript: 'AppleScript',
      arff: 'ARFF',
      asciidoc: 'AsciiDoc',
      asm6502: '6502 Assembly',
      aspnet: 'ASP.NET (C#)',
      autohotkey: 'AutoHotkey',
      autoit: 'AutoIt',
      basic: 'BASIC',
      csharp: 'C#',
      cpp: 'C++',
      coffeescript: 'CoffeeScript',
      csp: 'Content-Security-Policy',
      'css-extras': 'CSS Extras',
      django: 'Django/Jinja2',
      erb: 'ERB',
      fsharp: 'F#',
      glsl: 'GLSL',
      graphql: 'GraphQL',
      http: 'HTTP',
      hpkp: 'HTTP Public-Key-Pins',
      hsts: 'HTTP Strict-Transport-Security',
      ichigojam: 'IchigoJam',
      inform7: 'Inform 7',
      json: 'JSON',
      latex: 'LaTeX',
      livescript: 'LiveScript',
      lolcode: 'LOLCODE',
      'markup-templating': 'Markup templating',
      matlab: 'MATLAB',
      mel: 'MEL',
      n4js: 'N4JS',
      nasm: 'NASM',
      nginx: 'nginx',
      nsis: 'NSIS',
      objectivec: 'Objective-C',
      ocaml: 'OCaml',
      opencl: 'OpenCL',
      parigp: 'PARI/GP',
      php: 'PHP',
      'php-extras': 'PHP Extras',
      plsql: 'PL/SQL',
      powershell: 'PowerShell',
      properties: '.properties',
      protobuf: 'Protocol Buffers',
      q: 'Q (kdb+ database)',
      jsx: 'React JSX',
      tsx: 'React TSX',
      renpy: "Ren'py",
      rest: 'reST (reStructuredText)',
      sas: 'SAS',
      sass: 'Sass (Sass)',
      scss: 'Sass (Scss)',
      sql: 'SQL',
      typescript: 'TypeScript',
      vbnet: 'VB.Net',
      vhdl: 'VHDL',
      vim: 'vim',
      wiki: 'Wiki markup',
      xojo: 'Xojo (REALbasic)',
      yaml: 'YAML',
    };
    Prism.plugins.toolbar.registerButton('show-language', function(t) {
      var a = t.element.parentNode;
      if (a && /pre/i.test(a.nodeName) && t.language) {
        var s =
          e[t.language] ||
          t.language.substring(0, 1).toUpperCase() + t.language.substring(1),
          i = document.createElement('span');
        return (i.textContent = s), i;
      }
    });
  }
})();
