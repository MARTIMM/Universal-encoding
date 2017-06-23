# Designing the stuff

## Diagrams

```plantuml

title Classes in the UEncode package

class C as "Client"
class UT as "User\nType"


package "UEncoding" #e0e0e0 {
  'class E as "UEncoding"
  class EN as "Engine"
  'class ED as "ED" << (R,#ffaa00) Role >>

  'class M as "Map"
  class MPT as "Module\nProvided\nType"

  'ED <|-- MPT
  'ED <|- UT

  C -> EN
  'MPT --> EN
  'UT --> EN

  MPT <--* C
  UT <--* C

  'G <|-- UT
  'M <-* UT
  'M *-> G
  'E <--* M
}


```
## Tests

Important to note is that running the tests several times will show that the outcome fluctuates.

### Encoding tests

class: 2.9510 wallclock secs @ 1694.3155/s (n=5000)
mapping: 1.0475 wallclock secs @ 4773.3954/s (n=5000)
sub-mapping: 2.1879 wallclock secs @ 2285.3020/s (n=5000)
user-pattern: 1.6134 wallclock secs @ 3099.0275/s (n=5000)

|              | Rate   | mapping | sub-mapping | class | user-pattern |
|--------------|--------|---------|-------------|-------|--------------|
| mapping      | 4773/s | --      | 109%        | 182%  | 54%          |
| sub-mapping  | 2285/s | -52%    | --          | 35%   | -26%         |
| class        | 1694/s | -65%    | -26%        | --    | -45%         |
| user-pattern | 3099/s | -35%    | 36%         | 83%   | --           |

In preparation of using threads the calls to store-value() are moved from code stored in procedure hashes to check-and-call(). It makes the procedures somewhat slower and needs to be investigated, but makes the code much simpler as well as class.

Timing 5000 iterations of class, mapping, sub-mapping, user-pattern...
class: 2.9054 wallclock secs @ 1720.9603/s (n=5000)
mapping: 1.0486 wallclock secs @ 4768.1665/s (n=5000)
sub-mapping: 2.1087 wallclock secs @ 2371.0965/s (n=5000)
user-pattern: 1.6150 wallclock secs @ 3095.9388/s (n=5000)

|              | Rate   | mapping | sub-mapping | class | user-pattern |
|--------------|--------|---------|-------------|-------|--------------|
| mapping      | 4768/s | --      | 101%        | 177%  | 54%          |
| sub-mapping  | 2371/s | -50%    | --          | 38%   | -23%         |
| class        | 1721/s | -64%    | -27%        | --    | -44%         |
| user-pattern | 3096/s | -35%    | 31%         | 80%   | --           |
